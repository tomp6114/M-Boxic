import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController{
  bool _notificaton = false;

  void _updateSwitch(bool newValue) {
  
      _notificaton = newValue;
    update();
  }

  Widget buildSwitch() {
    return CupertinoSwitch(
      value: _notificaton,
      onChanged: _updateSwitch,
      activeColor: const Color.fromARGB(255, 86, 209, 14),
      trackColor: const Color.fromARGB(255, 113, 116, 113),
    );
  }
}