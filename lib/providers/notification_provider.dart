import 'package:flutter/material.dart';
import 'package:gis_flutter_frontend/core/development/console.dart';
import 'package:gis_flutter_frontend/services/base_client_controller.dart';

import '../core/config/api_config.dart';
import '../services/base_client.dart';

class NotificationProvider extends ChangeNotifier with BaseController {
  sendNotification(
      {required BuildContext context,
      String? body,
      String? title,
      String? image,
      String? registrationIdToken}) async {
    Map data = {
      "to": registrationIdToken,
      "notification": {
        "body": body ?? "Test notification",
        "title": title ?? "Testing",
        "sound": true,
        "image": image ??
            "https://cdn2.vectorstock.com/i/1000x1000/23/91/small-size-emoticon-vector-9852391.jpg",
        "android_channel_id": "pushnotificationappchannel",
      },
    };
    consolelog(data);

    var response = await BaseClient()
        .post(
          ApiConfig.baseUrl,
          "https://fcm.googleapis.com/fcm/send",
          data,
          hasTokenHeader: false,
          isNotification: true,
          isCustomApi: true,
        )
        .catchError(handleError);
    if (response == null) return false;

    consolelog(response);
  }
}
