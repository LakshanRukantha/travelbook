import 'package:go_router/go_router.dart';
import 'package:travelbook/screens/home.dart';
import 'package:travelbook/screens/test_screen.dart';

import 'layouts/main_layout.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
            path: '/', name: "/", builder: (context, state) => const Home()),
        GoRoute(
            path: '/test',
            name: "/test",
            builder: (context, state) => const TestScreen()),
      ],
    ),
  ],
);
