import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileEmail = "Loading...";
  String profileUsername = "Loading username...";
  String userImage = "";
  String profileBio = "";
  String profileLocation = "";

  int postsCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  final defaultImage = "assets/images/developers/user.webp";

  List<Map<String, dynamic>> userPosts = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchUserPosts();
  }

  Future<void> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final uid = currentUser.uid;
        final userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final userData = userDoc.data();

        setState(() {
          profileEmail = currentUser.email ?? 'No Email';
          profileUsername = userData?['name'] ?? 'No Name';
          userImage = userData?['userImage'] ?? "";
          profileBio = userData?['bio'] ?? '';
          profileLocation = userData?['location'] ?? '';
          followersCount =
              (userData?['followers'] as List<dynamic>?)?.length ?? 0;
          followingCount =
              (userData?['following'] as List<dynamic>?)?.length ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchUserPosts() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('posted_by', isEqualTo: currentUser.email)
            .orderBy('time', descending: true)
            .get();

        setState(() {
          postsCount = querySnapshot.docs.length;
          userPosts = querySnapshot.docs.map((doc) => doc.data()).toList();
        });
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<void> _changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (pickedFile != null && currentUser != null) {
      File imageFile = File(pickedFile.path);
      String fileName = 'profile_${currentUser.uid}.jpg';

      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(fileName);
        await ref.putFile(imageFile);

        String downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'userImage': downloadUrl});

        setState(() {
          userImage = downloadUrl;
        });
      } catch (e) {
        print("Failed to upload profile image: $e");
      }
    }
  }

  Widget profileStat(String count, String label, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(count,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget postItem(String text, int likes, String time, String image) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: image.startsWith("http")
              ? Image.network(image, width: 50, height: 50, fit: BoxFit.cover)
              : Image.asset(image, width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Text(text),
        subtitle: Text("$time  •  $likes Likes"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            GestureDetector(
              onTap: _changeProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: userImage.isNotEmpty
                    ? NetworkImage(userImage)
                    : AssetImage(defaultImage) as ImageProvider,
              ),
            ),
            SizedBox(height: 10),
            Text(profileUsername,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(profileEmail, style: TextStyle(color: Colors.grey)),
            if (profileLocation.isNotEmpty)
              Text(profileLocation, style: TextStyle(color: Colors.grey[600])),
            if (profileBio.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: Text(
                  profileBio,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                context.pushNamed("edit_profile");
              },
              child: Text("Edit Profile"),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                profileStat(postsCount.toString(), "Posts"),
                profileStat(followersCount.toString(), "Followers"),
                profileStat(followingCount.toString(), "Following"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                context.push("/new_post");
              },
              icon: Icon(Icons.add),
              label: Text("Add Post"),
            ),
            SizedBox(height: 10),
            userPosts.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No posts yet.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : Column(
                    children: userPosts.map((post) {
                      return postItem(
                        post["text"] ?? '',
                        post["likes"] ?? 0,
                        _formatTime(post["time"] ?? ''),
                        post["image"] ?? '',
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String isoTime) {
    try {
      final postDate = DateTime.parse(isoTime);
      final now = DateTime.now();
      final difference = now.difference(postDate);
      if (difference.inDays > 0) return "${difference.inDays}d ago";
      if (difference.inHours > 0) return "${difference.inHours}h ago";
      if (difference.inMinutes > 0) return "${difference.inMinutes}m ago";
      return "Just now";
    } catch (e) {
      return "";
    }
  }
}
