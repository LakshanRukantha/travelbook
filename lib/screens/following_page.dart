import 'package:flutter/material.dart';

class FollowingListPage extends StatelessWidget {
  final List<String> following;

  const FollowingListPage({super.key, required this.following});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Following")),
      body: ListView.builder(
        itemCount: following.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(following[index]));
        },
      ),
    );
  }
}
