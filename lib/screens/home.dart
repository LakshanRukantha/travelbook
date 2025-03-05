import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelbook/widgets/post_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

const _posts = [
  {
    "name": "John Doe",
    "location": "Demodara Nine Arch Bridge",
    "imageUrl":
        "https://d1ynolcus8dvgv.cloudfront.net/2019/01/nine-arch-2-5.jpg",
  },
  {
    "name": "Jane Doe",
    "location": "Ella Rock",
    "imageUrl":
        "https://mediaim.expedia.com/localexpert/44628457/b12440fc-6efb-4ade-aac9-62213d7eff1d.jpg?impolicy=resizecrop&rw=1005&rh=565",
  },
];

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TravelBook"),
        ),
        body: ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Column(
                  children: [
                    PostCard(
                      name: _posts[index]["name"] as String,
                      location: _posts[index]["location"] as String,
                      imageUrl: _posts[index]["imageUrl"] as String,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              );
            }));
  }
}
