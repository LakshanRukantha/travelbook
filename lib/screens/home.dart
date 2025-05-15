import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
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
    final userEmail = "rukanthalakshan@gmail.com";
    if (userEmail == null) return;

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
            onPressed: () {
              print("Notification button pressed");
            },
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Welcome ",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: "Lakshan!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.left,
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
                // final userEmail = FirebaseAuth.instance.currentUser?.email;
                final userEmail = "rukanthalakshan@gmail.com";
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
                            Image.network(imageUrl),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 14),
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
                                        onPressed: () =>
                                            toggleLike(postId, likedUsers),
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
