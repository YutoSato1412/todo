import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/widget/bottom_navigation_bar.dart';
import 'package:todo/todo/view/todo.dart';
import 'package:todo/schedule/view/schedule.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final todoNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'todo');
final calendarNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'calendar');
final scheduleNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'schedule');

final router =
    GoRouter(navigatorKey: rootNavigatorKey, initialLocation: '/todo', routes: [
  StatefulShellRoute.indexedStack(
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state, navigationShell) {
        return AppNavigationBar(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(navigatorKey: todoNavigatorKey, routes: [
          GoRoute(
            path: '/todo',
            name: 'todo',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: Todo()),
          ),
        ]),
        StatefulShellBranch(navigatorKey: calendarNavigatorKey, routes: [
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: Todo()),
          ),
        ]),
        StatefulShellBranch(navigatorKey: scheduleNavigatorKey, routes: [
          GoRoute(
            path: '/schedule',
            name: 'schedule',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: Calendar()),
          )
        ]),
      ])
]);
