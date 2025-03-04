import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelbook/widgets/post_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TravelBook"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
                PostCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
