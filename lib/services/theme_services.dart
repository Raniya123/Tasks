import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final _box = GetStorage();
  final _key = "isDarkMode";
  _saveThemeToBox(bool isDarkTheme) => _box.write(_key, isDarkTheme);
  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchtheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
