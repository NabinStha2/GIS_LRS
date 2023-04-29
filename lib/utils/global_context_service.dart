import 'package:flutter/material.dart';

class GlobalContextService {
  static GlobalKey<NavigatorState> globalContext = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
}
