import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final String? title;
  final AppBar appBar;
  final List<Widget> widgets;
  final double customHeight;

  const BaseAppBar({
    Key? key,
    this.backgroundColor = const Color.fromARGB(255, 0, 157, 209),
    this.title,
    required this.appBar,
    this.widgets = const [],
    this.customHeight = 0.0,
  })  : assert(customHeight >= 0.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(title!) : null,
      backgroundColor: backgroundColor,
      centerTitle: true,
      actions: widgets.isNotEmpty ? widgets : appBar.actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      customHeight > 0 ? customHeight : appBar.preferredSize.height);
}
