import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/calender/veiw_model/calender_repository.dart';

// 左の時限の表示WIdget
class PeriodWidget extends HookConsumerWidget {
  final String schedulePeriod;
  final StartTimeRepository startTimeRepository = StartTimeRepository();
  PeriodWidget({super.key, required this.schedulePeriod});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeState = useState<DateTime>(DateTime.now());
    useEffect(() {
      // 初回表示時にローカルに保存された時間を取得
      startTimeRepository
          .getValue('startTime$schedulePeriod')
          .then((storedTime) {
        if (storedTime != null && storedTime.isNotEmpty) {
          final storedDateTime = DateTime.parse('2023-01-01 $storedTime:00');
          timeState.value = storedDateTime;
        } else {
          // ローカルに保存された時間がない場合、デフォルトは00:00に設定
          timeState.value = DateTime.parse('2023-01-01 00:00:00');
        }
      });
      return null;
    }, []);

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      width: MediaQuery.of(context).size.width / 7,
      height: MediaQuery.of(context).size.height * 1.1 / 10,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () async {
                // 時間選択用のダイアログを表示し、選択された時間をtimeStateに保存
                DateTime? pickedTime = await DatePicker.showTimePicker(
                  context,
                  showTitleActions: true,
                  showSecondsColumn: false,
                  onConfirm: (time) {
                    timeState.value = time;
                    final formattedTime =
                        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setString(
                          'startTime$schedulePeriod', formattedTime);
                    });
                  },
                  currentTime: DateTime.now(),
                );
                if (pickedTime != null) {}
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 5),
                  // 選択された時間を表示
                  child: Text(
                    '${timeState.value.toLocal().hour.toString().padLeft(2, '0')}:${timeState.value.toLocal().minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 12),
                  )),
            ),
          ),
          const Spacer(),
          Text(
            // 時限を表示
            schedulePeriod,
            style: const TextStyle(fontSize: 20.0),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}