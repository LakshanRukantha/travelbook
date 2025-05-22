import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/authentication.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> posts = [];
  String userEmail = "";
  Map<String, dynamic>? user;

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;
    final uid = currentUser.uid;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data();
    }
    return null;
  }

  void fetchUserData() async {
    Map<String, dynamic>? userData = await getCurrentUser();

    if (mounted && userData != null) {
      setState(() {
        user = userData;
        userEmail = FirebaseAuth.instance.currentUser!.email ?? '';
      });
      print("User name: ${userData['name']}");
      print("User image: ${userData['userImage']}");
    } else {
      print("No user data found.");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    print("user: $user");
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('posts').get();
      setState(() {
        posts = snapshot.docs.map((doc) {
          var postData = doc.data();
          postData['post_id'] = doc.id;
          return postData;
        }).toList();
      });
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  Future<void> toggleLike(String postId, List<dynamic> likedUsers) async {
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final isLiked = likedUsers.contains(userEmail);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(postRef);
        final currentLikes = snapshot['likes'] ?? 0;

        final newLikes = isLiked ? currentLikes - 1 : currentLikes + 1;

        transaction.update(postRef, {
          'liked_users': isLiked
              ? FieldValue.arrayRemove([userEmail])
              : FieldValue.arrayUnion([userEmail]),
          'likes': newLikes < 0 ? 0 : newLikes,
        });
      });

      await fetchPosts(); // Refresh posts after update
    } catch (e) {
      print("Failed to toggle like: $e");
    }
  }

  String _capitalizeEachWord(String input) {
    return input
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  Future<String?> getUserProfileImage(String email) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data()['userImage'];
      }
    } catch (e) {
      print("Error fetching user profile image: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Travel Book",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () async {
              await AuthServices().signOutUser(context);
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white), // White icon
            onSelected: (value) async {
              print("Selected: $value");
              switch (value) {
                case "weather_today":
                  context.push('/weather');
                  break;
                case "sign_out":
                  await AuthServices().signOutUser(context);
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: "weather_today",
                child: Row(
                  children: [
                    Icon(Icons.wb_sunny, color: Colors.black),
                    SizedBox(width: 8),
                    Text("Today's Weather"),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: "sign_out",
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black),
                    SizedBox(width: 8),
                    Text("Sign Out"),
                  ],
                ),
              ),
            ],
          )
        ],
        backgroundColor: Colors.blue,
      ),
      body: user == null || posts.isEmpty
          ? Center(child: CircularProgressIndicator(color: Colors.blue))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Welcome ",
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "${_capitalizeEachWord(user?['name'].split(" ")[0] ?? '')}!",
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "Explore the beauty of Sri Lanka",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final postId = post["post_id"] ?? "Unknown ID";
                      final likedUsers = post["liked_users"] ?? [];
                      final name = post["name"] ?? "Unknown";
                      final location = post["location"] ?? "Unknown location";
                      final imageUrl = post["image"] ?? "";
                      final caption = post["caption"] ?? "";
                      final likes = post["likes"]?.toString() ?? "0";
                      final isLiked = likedUsers.contains(userEmail);
                      final postedBy = post["posted_by"] ?? "Unknown";

                      return Card(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Profile Image
                                    FutureBuilder<String?>(
                                      future: getUserProfileImage(postedBy),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.grey[300],
                                              child: const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors.blue,
                                                          strokeWidth: 2)),
                                            ),
                                          );
                                        }
                                        if (snapshot.hasData &&
                                            snapshot.data != null &&
                                            snapshot.data!.isNotEmpty) {
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Image.network(
                                              snapshot.data!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        }
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.person,
                                                size: 30),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text(
                                                    name,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                    padding: EdgeInsets.zero,
                                                    minimumSize:
                                                        const Size(50, 30),
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap),
                                                child: const Text(
                                                  "Follow",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  size: 14,
                                                  color: Colors.red,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  location,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (imageUrl.isNotEmpty)
                              Stack(
                                children: [
                                  Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 14),
                                        child: Row(
                                          children: [
                                            Text(
                                              likes,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                              ),
                                              color: Colors.white,
                                              onPressed: () => toggleLike(
                                                  postId, likedUsers),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                caption,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
