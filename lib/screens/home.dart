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
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return userDoc.data();
    }
    return null;
  }

  void fetchUserData() async {
    Map<String, dynamic>? userData = await getCurrentUser();

    if (userData != null) {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: user?['userImage'] != null && user!['userImage'].isNotEmpty
                ? CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user!['userImage']),
                  )
                : const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person, size: 24),
                  ),
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: user == null || posts == []
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
                            // Text(userEmail,
                            //     textAlign: TextAlign.left,
                            //     style: const TextStyle(
                            //       fontSize: 16,
                            //       color: Colors.black54,
                            //     )),
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

                      return Card(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    " is at ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  Flexible(
                                    child: Text(
                                      location,
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
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
