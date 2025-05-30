import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current location from GoRouter
    final String currentRoute = GoRouterState.of(context).uri.toString();

    // Routes where bottom nav bar should be shown
    final showNavRoutes = ['/', '/map', '/chat', '/settings', '/profile'];

    // If current route is not in showNavRoutes, hide bottom nav bar
    if (!showNavRoutes.contains(currentRoute)) {
      return const SizedBox.shrink();
    }

    // Determine the current index based on route
    int getCurrentIndex() {
      switch (currentRoute) {
        case '/':
          return 0;
        case '/map':
          return 1;
        case '/chat':
          return 2;
        case '/settings':
          return 3;
        case '/profile':
          return 4;
        default:
          return 0; // Default to home index just in case
      }
    }

    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      color: Colors.blue,
      animationDuration: const Duration(milliseconds: 300),
      height: 70,
      index: getCurrentIndex(),
      items: const [
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.map_rounded, size: 30, color: Colors.white),
        Icon(Icons.android, size: 30, color: Colors.white),
        Icon(Icons.settings, size: 30, color: Colors.white),
        Icon(Icons.account_circle, size: 30, color: Colors.white),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/');
            break;
          case 1:
            context.go('/map');
            break;
          case 2:
            context.go('/chat');
            break;
          case 3:
            context.go('/settings');
            break;
          case 4:
            context.go('/profile');
            break;
          default:
            context.go('/'); // Default case to home
            break;
        }
      },
    );
  }
}
