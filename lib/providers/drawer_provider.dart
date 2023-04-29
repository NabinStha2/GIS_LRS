import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/development/console.dart';

class DrawerProvider extends ChangeNotifier {
  int drawerSelectedIndex = 0;

  changeDrawerSelectedIndex(int value) {
    drawerSelectedIndex = value;
    consolelog(drawerSelectedIndex);
    notifyListeners();
  }
}
