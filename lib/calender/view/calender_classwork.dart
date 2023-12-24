import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/calender/veiw_model/classwork_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassworkWidget extends HookConsumerWidget {
  final String schedulePeriod;
  final String dayOfWeek;
  final ClassDataRepository classDataRepository = ClassDataRepository();

  ClassworkWidget({
    super.key,
    required this.schedulePeriod,
    required this.dayOfWeek,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boxSizeW = MediaQuery.of(context).size.width / 7;
    final boxSizeH = MediaQuery.of(context).size.height * 1.1 / 10;
    final classNameState = useState<String?>('');
    final classPlaceState = useState<String?>('');
    final classNoteState = useState<String?>('');

    useEffect(() {
      // 初回表示時にローカルに保存された授業情報を取得
      SharedPreferences.getInstance().then((prefs) {
        final className =
            prefs.getString('class_$dayOfWeek${schedulePeriod}Name') ?? '';
        classNameState.value = className;

        final classPlace =
            prefs.getString('class_$dayOfWeek${schedulePeriod}Place') ?? '';
        classPlaceState.value = classPlace;

        final classNote =
            prefs.getString('class_$dayOfWeek${schedulePeriod}Note') ?? '';
        classNoteState.value = classNote;
      });
      return null;
    }, []);

    return Container(
      alignment: const Alignment(0.3, -0.5),
      width: boxSizeW,
      height: boxSizeH,
      child: GestureDetector(
        onTap: () async {
          // ダイアログで授業情報を入力
          final enteredData = await showDialog<Map<String, String>>(
            context: context,
            builder: (BuildContext context) {
              String? className;
              String? classPlace;
              String? classNote;

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
                          onChanged: (text1) {
                            className = text1;
                          },
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.all(5),
                          child: const Text('教室'),
                        ),
                        TextField(
                          onChanged: (text2) {
                            classPlace = text2;
                          },
                        ),
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
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            onChanged: (text3) {
                              classNote = text3;
                            },
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
                        'name': className ?? '',
                        'place': classPlace ?? '',
                        'note': classNote ?? '',
                      };
                      print(enteredData); // デバッグ情報を追加
                      Navigator.pop(context, enteredData);
                    },
                    child: const Text('保存'),
                  ),
                ],
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
                classNameState.value ?? '', // Stateの値を表示
                style: const TextStyle(fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.only(right: 2, left: 2),
                margin: const EdgeInsets.only(right: 3, left: 3),
                color: Colors.white,
                child: Text(
                  classPlaceState.value ?? '',
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
