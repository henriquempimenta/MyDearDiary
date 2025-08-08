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
          ],
          currentIndex: 0,
          onTap: (int index) {
            // Only one tab, so no navigation needed
          },
        ),
      ),
    );
  }
}
