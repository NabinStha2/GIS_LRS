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
      List<String>? registrationIdToken}) async {
    Map data = {
      "registration_ids": registrationIdToken ??
          [
            "ebGKJ5MsQbmL28SQSucE-r:APA91bG1NQb4s8bQ2twXJTrb9YGEedKlqvMkvAhKGbz8ROERNW9XF_TuCZV98_Tgz4mM8asFaprBEKBKT9EwPhPrnGO3jmm8LyDX40r24M6XzQsHvMIl7jln49czVEvXDAOGFRPTZCx1"
          ],
      "notification": {
        "body": body ?? "I love you pratima shrestha.",
        "title": title ?? "My pukulu",
        "image": image ??
            "https://cdn2.vectorstock.com/i/1000x1000/23/91/small-size-emoticon-vector-9852391.jpg",
        "sound": true
      },
      "data": {"_id": 1}
    };

    var response = await BaseClient()
        .post(
          ApiConfig.baseUrl,
          "https://fcm.googleapis.com/fcm/send",
          data,
          hasTokenHeader: true,
          isCustomApi: true,
        )
        .catchError(handleError);
    if (response == null) return false;

    consolelog(response);
  }
}
