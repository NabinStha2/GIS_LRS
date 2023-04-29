import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToasts {
  static void showToast({
    String? msg,
    Color color = Colors.green,
  }) {
    // Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg.toString(),
        // webBgColor: color,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        // webPosition: "right",
        // webShowClose: true,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}

errorToast({String msg = "please fill the data"}) {
  CustomToasts.showToast(msg: msg, color: Colors.red);
}

successToast({String? msg}) {
  CustomToasts.showToast(msg: msg, color: Colors.green);
}
