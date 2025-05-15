import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard(
      {super.key,
      required this.name,
      required this.location,
      required this.imageUrl});

  final String name;
  final String location;
  final String imageUrl;

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name is at $location",
                    style: TextStyle(fontSize: 18),
                    softWrap: true,
                  ),
                  Text(
                    "2 hours ago",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Card(
          child: Image.network(
            imageUrl,
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
                softWrap: true,
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
