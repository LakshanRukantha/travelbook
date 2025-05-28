import 'package:go_router/go_router.dart';
import 'package:travelbook/screens/edit_profile.dart';
import 'package:travelbook/screens/home.dart';
import 'package:travelbook/screens/profile.dart';
import 'package:travelbook/screens/map.dart';

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
            builder: (context, state) => const MapScreen()),
        GoRoute(
          path: '/profile',
          name: "/profile",
          builder: (context, state) => ProfilePage(),
        ),
        GoRoute(
          path: '/edit_profile',
          name: "edit_profile",
          builder: (context, state) => EditProfilePage(),
        ),
      ],
    ),
  ],
);
