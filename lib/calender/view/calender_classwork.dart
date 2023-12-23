import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClassworkWidget extends HookConsumerWidget {
  const ClassworkWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      width: MediaQuery.of(context).size.width / 7,
      height: MediaQuery.of(context).size.height * 1.1 / 10,
      child: const Column(
        children: [],
      ),
    );
  }
}
