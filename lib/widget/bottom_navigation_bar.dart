import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: navigationShell,
        bottomNavigationBar: SizedBox(
          height: deviceHeight / 10,
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.list), label: 'todo'),
              NavigationDestination(icon: Icon(Icons.event), label: 'calender'),
              NavigationDestination(
                  icon: Icon(Icons.schedule), label: 'schedule'),
            ],
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ));
  }
}
