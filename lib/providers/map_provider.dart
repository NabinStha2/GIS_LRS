import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/development/console.dart';

class MapProvider extends ChangeNotifier {
  int tileLayerIndex = 0;

  changeTileLayerIndex(int value) {
    tileLayerIndex = value;
    consolelog(tileLayerIndex);
    notifyListeners();
  }
}
