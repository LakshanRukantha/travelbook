import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current route location
    String currentRoute = GoRouterState.of(context).uri.toString();

    // App routes
    int getCurrentIndex() {
      switch (currentRoute) {
        case '/':
          return 0;
        case '/test':
          return 1;
        case '/test2':
          return 2;
        case '/settings':
          return 3;
        case '/profile':
          return 4;
        default:
          return 0; // Hide bottom nav if route not found
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
            context.go('/'); // Use `go` for navigation inside bottom nav
            break;
          case 1:
            context.go('/test');
            break;
          case 2:
            context.go('/test2');
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
