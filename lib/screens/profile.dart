import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileEmail = "Loading...";
  String profileUsername = "Loading username...";
  bool isLoadingPosts = true;
  String userImage = "";
  String profileBio = "";
  String profileLocation = "";

  int postsCount = 0;
  int followersCount = 0;
  int followingCount = 0;

  List<String> followersList = [];
  List<String> followingList = [];

  final defaultImage = "assets/images/developers/user.webp";
  List<Map<String, dynamic>> userPosts = [];

  @override
  void initState() {
    super.initState();
    initProfile();
  }

  Future<void> initProfile() async {
    await fetchUserData();
    await fetchUserPosts();
  }

  Future<void> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final uid = currentUser.uid;
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        final userData = userDoc.data();

        setState(() {
          profileEmail = currentUser.email ?? 'No Email';
          profileUsername = userData?['name'] ?? 'No Name';
          userImage = userData?['userImage'] ?? "";
          profileBio = userData?['bio'] ?? '';
          profileLocation = userData?['location'] ?? '';
          followersList = List<String>.from(userData?['followers'] ?? []);
          followingList = List<String>.from(userData?['following'] ?? []);
          followersCount = followersList.length;
          followingCount = followingList.length;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchUserPosts() async {
    setState(() {
      isLoadingPosts = true;
    });
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final userEmail = currentUser?.email;

      if (userEmail != null) {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('posts')
            .where('posted_by', isEqualTo: userEmail)
            .get();

        setState(() {
          postsCount = querySnapshot.docs.length;
          userPosts = querySnapshot.docs.map((doc) => doc.data()).toList();
        });
      }
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      setState(() {
        isLoadingPosts = false;
      });
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
        final ref = FirebaseStorage.instance.ref().child('profile_images').child(fileName);
        await ref.putFile(imageFile);
        String downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({'userImage': downloadUrl});
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
          Text(count, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget postItem(String text, int likes, String time, String image) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image.startsWith("http")
                  ? Image.network(image, width: 80, height: 80, fit: BoxFit.cover)
                  : Image.asset(image, width: 80, height: 80, fit: BoxFit.cover),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("$time  •  $likes Likes", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                try {
                  final postQuery = await FirebaseFirestore.instance
                      .collection('posts')
                      .where('caption', isEqualTo: text)
                      .where('posted_by', isEqualTo: FirebaseAuth.instance.currentUser?.email)
                      .get();

                  for (var doc in postQuery.docs) {
                    if (image.startsWith('https://')) {
                      try {
                        final ref = FirebaseStorage.instance.refFromURL(image);
                        await ref.delete();
                      } catch (e) {
                        print('Error deleting image from storage: $e');
                      }
                    }
                    await doc.reference.delete();
                  }

                  await fetchUserPosts();
                } catch (e) {
                  print('Error deleting post: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
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
            Text(profileUsername, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(profileEmail, style: TextStyle(color: Colors.grey)),
            if (profileLocation.isNotEmpty) Text(profileLocation, style: TextStyle(color: Colors.grey[600])),
            if (profileBio.isNotEmpty) Text(profileBio, style: TextStyle(fontStyle: FontStyle.italic)),
            ElevatedButton(
              onPressed: () => context.pushNamed("edit_profile"),
              child: Text("Edit Profile"),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                profileStat(postsCount.toString(), "Posts"),
                profileStat(followersCount.toString(), "Followers", () {
                  context.pushNamed("followers", extra: followersList);
                }),
                profileStat(followingCount.toString(), "Following", () {
                  context.pushNamed("following", extra: followingList);
                }),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.push("/new_post"),
              icon: Icon(Icons.add),
              label: Text("Add Post"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Text("My Posts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            isLoadingPosts
                ? CircularProgressIndicator()
                : userPosts.isEmpty
                    ? Text("No posts yet.")
                    : Column(children: userPosts.map((post) {
                        return postItem(
                          post["caption"] ?? '',
                          post["likes"] ?? 0,
                          _formatTime(post["time"] ?? ''),
                          post["image"] ?? '',
                        );
                      }).toList()),
          ],
        ),
      ),
    );
  }

  String _formatTime(dynamic time) {
    try {
      final postDate = time is Timestamp ? time.toDate() : DateTime.parse(time.toString());
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
