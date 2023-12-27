import 'package:flutter/material.dart';

class ClassworkInputDialog extends StatelessWidget {
  final TextEditingController classNameController;
  final TextEditingController classPlaceController;
  final TextEditingController classNoteController;
  final bool hidePlace;

  const ClassworkInputDialog({
    Key? key,
    required this.classNameController,
    required this.classPlaceController,
    required this.classNoteController,
    required this.hidePlace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      title: const Text("授業情報"),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.6,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text('授業名'),
              ),
              TextField(
                controller: classNameController,
                onChanged: (text) {},
              ),
              Offstage(
                  offstage: hidePlace,
                  child: Column(children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.all(5),
                      child: const Text('教室'),
                    ),
                    TextField(
                      controller: classPlaceController,
                      onChanged: (text) {},
                    ),
                  ])),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.all(5),
                child: const Text('メモ'),
              ),
              Scrollbar(
                thickness: 10,
                trackVisibility: true,
                thumbVisibility: true,
                interactive: true,
                child: TextField(
                  controller: classNoteController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  onChanged: (text) {},
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("キャンセル"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          onPressed: () async {
            final enteredData = {
              'name': classNameController.text,
              'place': classPlaceController.text,
              'note': classNoteController.text,
            };
            Navigator.pop(context, enteredData);
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}
