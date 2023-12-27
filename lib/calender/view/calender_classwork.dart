import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/calender/view/calender_classwork_dialog.dart';

class ClassworkWidget extends HookConsumerWidget {
  final String schedulePeriod;
  final String dayOfWeek;

  const ClassworkWidget({
    Key? key,
    required this.schedulePeriod,
    required this.dayOfWeek,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxSizeW = MediaQuery.of(context).size.width / 7;
    final boxSizeH = schedulePeriod != 'オンデマンド'
        ? MediaQuery.of(context).size.height * 1.1 / 10
        : MediaQuery.of(context).size.height * 1 / 10;
    final classNameController = useTextEditingController(text: '');
    final classPlaceController = useTextEditingController(text: '');
    final classNoteController = useTextEditingController(text: '');
    final classNameState = useState<String?>('');
    final classPlaceState = useState<String?>('');
    final classNoteState = useState<String?>('');

    useEffect(() {
      // 初回表示時にローカルに保存された授業情報を取得
      SharedPreferences.getInstance().then((prefs) {
        final className =
            prefs.getString('class_$dayOfWeek${schedulePeriod}Name') ?? '';
        classNameController.text = className;
        classNameState.value = className;

        final classPlace =
            prefs.getString('class_$dayOfWeek${schedulePeriod}Place') ?? '';
        classPlaceController.text = classPlace;
        classPlaceState.value = classPlace;

        final classNote =
            prefs.getString('class_$dayOfWeek${schedulePeriod}Note') ?? '';
        classNoteController.text = classNote;
        classNoteState.value = classNote;
      });
      return null;
    }, []);

    bool hidePlace = schedulePeriod == 'オンデマンド';

    return Container(
      alignment: const Alignment(0.3, -0.5),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      width: boxSizeW,
      height: boxSizeH,
      child: GestureDetector(
        onTap: () async {
          // ダイアログで授業情報を入力
          final enteredData = await showDialog<Map<String, String>>(
            context: context,
            builder: (BuildContext context) {
              // 授業情報を入力するDialog
              return ClassworkInputDialog(
                classNameController: classNameController,
                classPlaceController: classPlaceController,
                classNoteController: classNoteController,
                hidePlace: hidePlace,
              );
            },
          );

          // 入力された授業情報があればSharedPreferencesに保存
          if (enteredData != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(
                'class_$dayOfWeek${schedulePeriod}Name', enteredData['name']!);
            prefs.setString('class_$dayOfWeek${schedulePeriod}Place',
                enteredData['place']!);
            prefs.setString(
                'class_$dayOfWeek${schedulePeriod}Note', enteredData['note']!);

            // Stateを変更して再描画
            classNameState.value = enteredData['name'];
            classPlaceState.value = enteredData['place'];
            classNoteState.value = enteredData['note'];
          }
        },
        child: Container(
          alignment: Alignment.center,
          width: boxSizeW * 0.8,
          height: boxSizeH * 0.9,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 201, 229, 243),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2), // 影のずれる場所
                color: Colors.grey,
                spreadRadius: 0.5, // 大きさ
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                classNameState.value ?? '',
                textAlign: TextAlign.center, // Stateの値を表示
                style: const TextStyle(fontSize: 12),
              ),
              Offstage(
                offstage: classPlaceState.value == '',
                child: Container(
                  padding: const EdgeInsets.only(right: 2, left: 2),
                  margin: const EdgeInsets.only(right: 3, left: 3),
                  color: Colors.white,
                  child: Text(
                    classPlaceState.value ?? '',
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
