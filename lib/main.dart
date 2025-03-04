import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelbook/firebase_options.dart';
import 'package:travelbook/screens/home.dart';
import 'package:travelbook/screens/test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final GoRouter _router = GoRouter(routes: [
  GoRoute(
    name: '/',
    path: '/',
    builder: (context, state) => Home(),
  ),
  GoRoute(
    name: '/test',
    path: "/test",
    builder: (context, state) => const TestScreen(),
  )
]);

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Travel Book",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}
