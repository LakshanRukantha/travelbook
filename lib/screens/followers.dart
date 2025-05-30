import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowersPage extends StatefulWidget {
  final List<String> followerEmails;

  const FollowersPage({Key? key, required this.followerEmails})
      : super(key: key);

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  List<Map<String, dynamic>> followersData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFollowers();
  }

  Future<void> fetchFollowers() async {
    try {
      List<Map<String, dynamic>> loadedFollowers = [];
      final batchSize = 10;

      for (int i = 0; i < widget.followerEmails.length; i += batchSize) {
        final batchEmails =
            widget.followerEmails.skip(i).take(batchSize).toList();

        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', whereIn: batchEmails)
            .get();

        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          data['uid'] = doc.id;
          loadedFollowers.add(data);
        }
      }

      setState(() {
        followersData = loadedFollowers;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading followers: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Followers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : followersData.isEmpty
              ? const Center(child: Text('No followers found.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: followersData.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final follower = followersData[index];
                    final imageUrl = follower['userImage'] as String? ?? '';
                    final name = follower['name'] as String? ?? 'No Name';
                    final email = follower['email'] as String? ?? 'No Email';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                        backgroundColor: Colors.grey.shade300,
                        child: imageUrl.isEmpty
                            ? Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '?',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )
                            : null,
                      ),
                      title: Text(name),
                      subtitle: Text(email),
                      onTap: () {},
                    );
                  },
                ),
    );
  }
}
