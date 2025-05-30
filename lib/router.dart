import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:travelbook/layouts/main_layout.dart';
import 'package:travelbook/screens/chat_bot.dart';
import 'package:travelbook/screens/edit_profile.dart';
import 'package:travelbook/screens/home.dart';
import 'package:travelbook/screens/log_in.dart';
import 'package:travelbook/screens/notifications.dart';
import 'package:travelbook/screens/profile.dart';
import 'package:travelbook/screens/sign_up.dart';
import 'package:travelbook/screens/test_screen.dart';
import 'package:travelbook/router_refresh.dart';

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
          path: '/test',
          name: '/test',
          builder: (context, state) => const TestScreen(),
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
            builder: (context, state) => const ChatBot()),
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
      ],
    ),
  ],
);
