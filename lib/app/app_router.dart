import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/views/dashboard_page.dart';
import '../../presentation/views/events_page.dart';
import '../../presentation/views/event_entry_page.dart';
import '../../presentation/widgets/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (BuildContext context, GoRouterState state) {
            return const DashboardPage();
          },
        ),
        GoRoute(
          path: '/events',
          builder: (BuildContext context, GoRouterState state) {
            return const EventsPage();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/new-event',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const EventEntryPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/edit-event/:id',
      pageBuilder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CustomTransitionPage(
          key: state.pageKey,
          child: EventEntryPage(), // TODO: Pass the event to the page
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
