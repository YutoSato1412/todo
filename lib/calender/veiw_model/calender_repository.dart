import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class StartTimeRepository {
  StartTimeRepository();

  // 複数のキーと対応する値を保存する
  Future<void> saveValues(Map<String, String> values) async {
    final prefs = await SharedPreferences.getInstance();
    values.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  // 複数のキーに対応する値を取得する
  Future<String?> getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}

// Function to clear SharedPreferences data
void clearSharedPreferences(ValueNotifier<bool> clearFlag) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();

  // Stateを変更して再描画をトリガー
  clearFlag.value = !clearFlag.value;
}
