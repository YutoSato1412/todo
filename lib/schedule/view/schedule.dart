import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/schedule/view/schedule_period.dart';
import 'package:todo/schedule/view/schedule_classwork.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 時間割全体を表すWidget
class Calendar extends HookConsumerWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceHeight = MediaQuery.of(context).size.height;

    const showDebugIcon = false; // Debug用のローカルの値を削除するIconの表示
    final clearFlag =
        useState<bool>(false); // SharedPreferencesの値を削除したことを判定するFlag

    List<String> list = ['', '月', '火', '水', '木', '金', '土'];

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(deviceHeight / 20), // Appbarの高さ指定
            child: AppBar(
              centerTitle: true,
              title: const Text('時間割'),
              backgroundColor: Colors.cyan,
              actions: [
                Visibility(
                  visible: showDebugIcon,
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                    ),
                    onPressed: () {
                      clearSharedPreferences(clearFlag);
                    },
                  ),
                )
              ],
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              (SizedBox(
                // SizedBoxで時間割部分の大きさ指定
                height: deviceHeight * 16 / 20,
                //height: deviceHeight * 14.02 / 20,

                child: ListView.separated(
                  // 横列の作成
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return BuildListItem(text: list[index]);
                  },
                  // 縦線の表示
                  separatorBuilder: (BuildContext context, int index) {
                    return const VerticalDivider(
                      width: 0,
                      thickness: 3,
                      color: Colors.black12,
                    );
                  },
                  itemCount: list.length,
                ),
              )),
            ],
          ),
        ));
  }
}

// 各枠に入れる内容を返すWidget
// ignore: must_be_immutable
class BuildListItem extends HookConsumerWidget {
  final String text;
  List<String> scheduleList = <String>[
    ' ',
    '1限',
    '2限',
    '3限',
    '4限',
    '5限',
    '6限',
    'オンデマンド'
  ];

  BuildListItem({super.key, required this.text});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.zero, // margin,paddingを0にしないと綺麗に7等分出来ない
        padding: EdgeInsets.zero,
        width: deviceWidth / 7,
        child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(), // スクロールを禁止
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                // 曜日用
                return Container(
                  alignment: Alignment.center,
                  height: deviceHeight / 25, // 曜日部分の大きさ指定
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                );
              } else if (text == '') {
                // 左の時限用
                return PeriodWidget(schedulePeriod: scheduleList[index]);
              } else if (index == scheduleList.length) {
                // 一番下の横線表示用
                return const Divider(
                  height: 0,
                  thickness: 3,
                  color: Colors.black12,
                );
              } else {
                // 授業表示用
                return ClassworkWidget(
                  schedulePeriod: scheduleList[index],
                  dayOfWeek: text,
                );
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              // 枠線を作成
              return const Divider(
                height: 0,
                thickness: 3,
                color: Colors.black12,
              );
            },
            itemCount: scheduleList.length + 1)); // +1することで一番下の横線を表示可能
  }
}

// SharedPreferences のデータを削除する用
void clearSharedPreferences(ValueNotifier<bool> clearFlag) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();

  // Stateを変更して再描画をトリガー
  clearFlag.value = !clearFlag.value;
}
