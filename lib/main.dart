import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travelbook/firebase_options.dart';
import 'package:travelbook/screens/test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Travel Book',
        home: TestScreen());
  }
}
