import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FollowingsPage extends StatefulWidget {
  final List<String> followingEmails;

  const FollowingsPage({Key? key, required this.followingEmails})
      : super(key: key);

  @override
  State<FollowingsPage> createState() => _FollowingsPageState();
}

class _FollowingsPageState extends State<FollowingsPage> {
  List<Map<String, dynamic>> followingsData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFollowings();
  }

  Future<void> fetchFollowings() async {
    try {
      List<Map<String, dynamic>> loadedFollowings = [];
      const batchSize = 10;

      for (int i = 0; i < widget.followingEmails.length; i += batchSize) {
        final batchEmails =
            widget.followingEmails.skip(i).take(batchSize).toList();

        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', whereIn: batchEmails)
            .get();

        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          data['uid'] = doc.id;
          loadedFollowings.add(data);
        }
      }

      setState(() {
        followingsData = loadedFollowings;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading followings: $e");
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
          'Followings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : followingsData.isEmpty
              ? const Center(child: Text('Not following anyone.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: followingsData.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final user = followingsData[index];
                    final imageUrl = user['userImage'] as String? ?? '';
                    final name = user['name'] as String? ?? 'No Name';
                    final email = user['email'] as String? ?? 'No Email';

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
