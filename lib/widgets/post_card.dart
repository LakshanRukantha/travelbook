import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  final name = "Lakshan Rukantha";
  final location = "Badulla";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.account_circle,
              size: 45,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$name is at $location",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "2 hours ago",
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ],
        ),
        Card(
          child: Image.network(
            "https://www.sankileisure.com/wp-content/uploads/2020/07/demodara-bridge.jpg",
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Column(
            children: [
              Text(
                "Today I visited Demodara Nine Arch Bridge. It was a great experience.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.favorite_border),
                  SizedBox(width: 8),
                  Icon(Icons.comment),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
