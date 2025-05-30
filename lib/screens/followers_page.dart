import 'package:flutter/material.dart';

class FollowersListPage extends StatelessWidget {
  final List<String> followers;

  const FollowersListPage({super.key, required this.followers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Followers")),
      body: ListView.builder(
        itemCount: followers.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(followers[index]));
        },
      ),
    );
  }
}
