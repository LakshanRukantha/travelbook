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
  Set<String> localFollowing = {};
  Map<String, String?> profileImageCache = {};
  Map<String, String> fullNameCache = {};

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
        localFollowing = Set<String>.from(userData['following'] ?? []);
      });
    } else {
      context.push("/login");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
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

  void toggleLike(String postId) {
    final index = posts.indexWhere((post) => post['post_id'] == postId);
    if (index == -1) return;

    final isLiked = (posts[index]['liked_users'] as List).contains(userEmail);

    // Real-time update
    setState(() {
      if (isLiked) {
        (posts[index]['liked_users'] as List).remove(userEmail);
        posts[index]['likes'] = (posts[index]['likes'] ?? 1) - 1;
      } else {
        (posts[index]['liked_users'] as List).add(userEmail);
        posts[index]['likes'] = (posts[index]['likes'] ?? 0) + 1;
      }
    });

    // Background Firestore update
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    postRef.update({
      'liked_users': isLiked
          ? FieldValue.arrayRemove([userEmail])
          : FieldValue.arrayUnion([userEmail]),
      'likes': FieldValue.increment(isLiked ? -1 : 1),
    }).catchError((error) {
      // Revert if failed
      setState(() {
        if (!isLiked) {
          (posts[index]['liked_users'] as List).remove(userEmail);
          posts[index]['likes'] = (posts[index]['likes'] ?? 1) - 1;
        } else {
          (posts[index]['liked_users'] as List).add(userEmail);
          posts[index]['likes'] = (posts[index]['likes'] ?? 0) + 1;
        }
      });
      print("Failed to update Firestore like: $error");
    });
  }

  Future<void> toggleFollowByEmails(
    currentUserEmail,
    postedByEmail,
  ) async {
    final firestore = FirebaseFirestore.instance;

    final yourUserQuery = await firestore
        .collection('users')
        .where('email', isEqualTo: currentUserEmail)
        .limit(1)
        .get();

    final postedByUserQuery = await firestore
        .collection('users')
        .where('email', isEqualTo: postedByEmail)
        .limit(1)
        .get();

    if (yourUserQuery.docs.isEmpty || postedByUserQuery.docs.isEmpty) {
      print('One or both users not found');
      return;
    }

    final yourUserDoc = yourUserQuery.docs.first;
    final postedByUserDoc = postedByUserQuery.docs.first;

    final yourUserRef = yourUserDoc.reference;
    final postedByUserRef = postedByUserDoc.reference;

    final yourFollowing =
        List<String>.from(yourUserDoc.data()['following'] ?? []);
    final postedByFollowers =
        List<String>.from(postedByUserDoc.data()['followers'] ?? []);

    final isFollowing = yourFollowing.contains(postedByEmail);

    if (isFollowing) {
      localFollowing.remove(postedByEmail);
      yourFollowing.remove(postedByEmail);
      postedByFollowers.remove(currentUserEmail);
    } else {
      localFollowing.add(postedByEmail);
      yourFollowing.add(postedByEmail);
      postedByFollowers.add(currentUserEmail);
    }

    await yourUserRef.update({'following': yourFollowing});
    await postedByUserRef.update({'followers': postedByFollowers});

    // ✅ Re-fetch and update user data locally
    final updatedUserData = await getCurrentUser();
    if (mounted && updatedUserData != null) {
      setState(() {
        user = updatedUserData;
      });
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

  Future<String> getUserFullName(String email) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        final name = data['name'];
        return name is String && name.trim().isNotEmpty ? name : "User";
      } else {
        return "User";
      }
    } catch (e) {
      print("Something went wrong while fetching the user name: $e");
      return "User";
    }
  }

  Future<String?> getCachedUserProfileImage(String email) async {
    if (profileImageCache.containsKey(email)) {
      return profileImageCache[email];
    }
    final image = await getUserProfileImage(email);
    profileImageCache[email] = image;
    return image;
  }

  Future<String> getCachedUserFullName(String email) async {
    if (fullNameCache.containsKey(email)) {
      return fullNameCache[email]!;
    }
    final name = await getUserFullName(email);
    fullNameCache[email] = name;
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: TextStyle(color: Colors.white, fontSize: 24),
            children: [
              TextSpan(
                text: 'Travel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Book',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () async {
              context.push("/notifications");
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
                      final location = post["location"] ?? "Unknown location";
                      final imageUrl = post["image"] ?? "";
                      final caption = post["caption"] ?? "";
                      final likes = post["likes"]?.toString() ?? "0";
                      final isLiked = likedUsers.contains(userEmail);
                      final postedBy = post["posted_by"] ?? "Unknown";
                      final isFollowing = localFollowing.contains(postedBy);
                      final isMe = postedBy == userEmail;

                      print("I'm Following: ${user?['following']}");

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
                                      future:
                                          getCachedUserProfileImage(postedBy),
                                      builder: (context, snapshot) {
                                        final imageUrl = snapshot.data;
                                        return CircleAvatar(
                                          backgroundImage: imageUrl != null
                                              ? NetworkImage(imageUrl)
                                              : null,
                                          child: imageUrl == null
                                              ? Icon(Icons.person)
                                              : null,
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
                                                  FutureBuilder<String?>(
                                                    future:
                                                        getCachedUserFullName(
                                                            postedBy),
                                                    builder:
                                                        (context, snapshot) {
                                                      final displayName =
                                                          snapshot.data ??
                                                              "User";
                                                      return Text(
                                                        displayName,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  await toggleFollowByEmails(
                                                    userEmail,
                                                    postedBy,
                                                  );
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize:
                                                      const Size(50, 30),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: !isMe
                                                    ? Text(
                                                        isFollowing
                                                            ? "Unfollow"
                                                            : "Follow",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.blueAccent,
                                                        ),
                                                      )
                                                    : Text(
                                                        "(You)",
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black38,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                              onPressed: () =>
                                                  toggleLike(postId),
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
