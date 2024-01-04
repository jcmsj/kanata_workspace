import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DurationNotifier extends ChangeNotifier {
  // ignore: prefer_final_fields
  int _totalTimeInMinutes = 0;
  int get hours => _totalTimeInMinutes ~/ 60;
  int get minutes => _totalTimeInMinutes % 60;
  // ignore: constant_identifier_names, non_constant_identifier_names
  final int DEFAULT_TOTAL_TIME_IN_MINUTES = 60;
  int get totalTimeInMinutes => _totalTimeInMinutes;
  set totalTimeInMinutes(int totalTimeInMinutes) {
    _totalTimeInMinutes = totalTimeInMinutes;
    notifyListeners();
  }

  String get activationTime {
    // get current time then add the total time
    return DateTime.now()
        .add(Duration(minutes: totalTimeInMinutes))
        .toString()
        .substring(11, 16);
  }

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    totalTimeInMinutes =
        prefs.getInt('totalTimeInMinutes') ?? DEFAULT_TOTAL_TIME_IN_MINUTES;
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalTimeInMinutes', totalTimeInMinutes);
  }
}
