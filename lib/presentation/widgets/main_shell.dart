import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'animated_gradient_background.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Events',
            ),
          ],
          currentIndex: _calculateSelectedIndex(context),
          onTap: (int index) => _onItemTapped(index, context),
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) {
      return 0;
    }
    if (location.startsWith('/events')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/dashboard');
        break;
      case 1:
        GoRouter.of(context).go('/events');
        break;
    }
  }
}
