import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:travelbook/layouts/main_layout.dart';
import 'package:travelbook/screens/about_us.dart';
import 'package:travelbook/screens/chat_bot.dart';
import 'package:travelbook/screens/edit_profile.dart';
import 'package:travelbook/screens/emergency_contact.dart';
import 'package:travelbook/screens/home.dart';
import 'package:travelbook/screens/log_in.dart';
import 'package:travelbook/screens/newpost.dart';
import 'package:travelbook/screens/notifications.dart';
import 'package:travelbook/screens/privacy_policy.dart';
import 'package:travelbook/screens/profile.dart';
import 'package:travelbook/screens/settings.dart';
import 'package:travelbook/screens/sign_up.dart';
import 'package:travelbook/router_refresh.dart';
import 'package:travelbook/screens/map.dart';
import 'package:travelbook/screens/weather.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final isLoggingIn = state.matchedLocation == '/login';

    final isProtected = [
      '/',
      '/profile',
      '/edit_profile',
      '/test',
    ].contains(state.matchedLocation);

    if (!isLoggedIn && isProtected) {
      return '/login';
    }

    if (isLoggedIn && isLoggingIn) {
      return '/';
    }

    return null;
  },
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: '/',
          builder: (context, state) => const Home(),
        ),
        GoRoute(
          path: '/map',
          name: '/map',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          path: '/login',
          name: '/login',
          builder: (context, state) => const Loginscreen(),
        ),
        GoRoute(
          path: '/signup',
          name: '/signup',
          builder: (context, state) => const SignUpscreen(),
        ),
        GoRoute(
          path: '/chat',
          name: "/chat",
          builder: (context, state) => const ChatBot(),
        ),
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
        GoRoute(
          path: '/notifications',
          name: "notifications",
          builder: (context, state) => NotificationsPage(),
        ),
        GoRoute(
          path: '/weather',
          name: "weather",
          builder: (context, state) => WeatherPage(),
        ),
        GoRoute(
          path: '/settings',
          name: "/settings",
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/about',
          name: "/about",
          builder: (context, state) => const AboutUs(),
        ),
        GoRoute(
          path: '/new_post',
          name: "/new_post",
          builder: (context, state) => const NewPost(),
        ),
        GoRoute(
          path: '/privacy_policy',
          name: "/privacy_policy",
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
        GoRoute(
          path: '/emergency_contact',
          name: "/emergency_contact",
          builder: (context, state) => EmergencyContactPage(),
        ),
      ],
    ),
  ],
);
