import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        title: const Text("Travel Book"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Welcome to Travel Book"),
            ElevatedButton(
              onPressed: () {
                context.pushNamed("/test");
              },
              child: const Text("Test Screen 01"),
            ),
          ],
        ),
      ),
    );
  }
}
