import 'package:flutter/material.dart';
import 'package:todo/route/route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/calender/veiw_model/calender_repository.dart';

final couponAnimationRepogitryProvider =
    Provider<StartTimeRepository>((ref) => StartTimeRepository());
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: router,
    );
  }
}
