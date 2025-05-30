import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowersPage extends StatelessWidget {
  final List<String> followerIds;

  const FollowersPage({super.key, required this.followerIds, required List<String> followers});

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    List<Map<String, dynamic>> users = [];

    for (String uid in followerIds) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        users.add(doc.data()!);
      }
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Followers")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text("No followers found."));

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: user['userImage'] != null && user['userImage'].toString().isNotEmpty
                      ? NetworkImage(user['userImage'])
                      : AssetImage("assets/images/developers/user.webp") as ImageProvider,
                ),
                title: Text(user['name'] ?? 'No Name'),
                subtitle: Text(user['email'] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
