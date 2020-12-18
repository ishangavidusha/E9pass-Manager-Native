import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService with ChangeNotifier {
  int footerMargin;
  int footerThikness;
  String footerColor;
  bool addFooter;

  SettingsService({this.footerMargin, this.footerThikness, this.footerColor, this.addFooter});

  Future<bool> setData(int _footerMargin, int _footerThikness, String _footerColor, bool _addFooter) async {
    footerMargin = _footerMargin;
    footerThikness = _footerThikness;
    footerColor = _footerColor;
    addFooter = _addFooter;
    SettingsService _settingsService = SettingsService(
      footerMargin: _footerMargin,
      footerThikness: _footerThikness,
      footerColor: _footerColor,
      addFooter:  _addFooter,
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    notifyListeners();
    return await prefs.setString('settings', jsonEncode(_settingsService));
  }

  Future<SettingsService> getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> settingsMap;
    final String settingStr = prefs.getString('settings');
    if (settingStr != null) {
      settingsMap = jsonDecode(settingStr) as Map<String, dynamic>;
    }

    if (settingsMap != null) {
      final SettingsService _settingsService = SettingsService.fromJson(settingsMap);
      footerMargin = _settingsService.footerMargin;
      footerThikness = _settingsService.footerThikness;
      footerColor = _settingsService.footerColor;
      addFooter = _settingsService.addFooter;
      print(_settingsService);
      notifyListeners();
      return _settingsService;
    } else {
      footerMargin = 5;
      footerThikness = 15;
      footerColor = 'ff404040';
      addFooter = false;
      notifyListeners();
      return SettingsService(
        footerMargin: 5,
        footerThikness: 15,
        footerColor: 'ff404040',
        addFooter: false
      );
    }
  }

  SettingsService.fromJson(Map<String, dynamic> json) {
    footerMargin = json['footerMargin'];
    footerThikness = json['footerThikness'];
    footerColor = json['footerColor'];
    addFooter = json['addFooter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['footerMargin'] = this.footerMargin;
    data['footerThikness'] = this.footerThikness;
    data['footerColor'] = this.footerColor;
    data['addFooter'] = this.addFooter;
    return data;
  }

  @override
  String toString() {
    return 'Footer Margin : ${footerMargin != null ? footerMargin : 'Not Found'}, Footer Thikness : ${footerThikness != null ? footerThikness : 'Not Found'}';
  }
}
