import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/widget/bottom_navigation_bar.dart';
import 'package:todo/todo/view/todo.dart';
import 'package:todo/calender/view/calender.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final page1NavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'todo');
final page2NavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'calendar');

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
        StatefulShellBranch(navigatorKey: page1NavigatorKey, routes: [
          GoRoute(
            path: '/todo',
            name: 'todo',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: Todo()),
          ),
        ]),
        StatefulShellBranch(navigatorKey: page2NavigatorKey, routes: [
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: Calendar()),
          )
        ]),
      ])
]);
