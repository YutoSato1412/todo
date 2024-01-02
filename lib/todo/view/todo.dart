import 'package:flutter/material.dart';
import 'package:todo/widget/base_appbar.dart';

class Todo extends StatelessWidget {
  const Todo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
      title: 'Settings',
      appBar: AppBar(),
    ));
  }
}
