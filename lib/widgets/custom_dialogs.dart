import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gis_flutter_frontend/core/routing/route_navigation.dart';
import '../core/app/dimensions.dart';
import 'custom_button.dart';
import 'custom_text.dart';

class CustomDialogs {
  static void cancelDialog(context) {
    back(context);
  }

  static fullLoadingDialog({String? data, required BuildContext context}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color(0xff141A31).withOpacity(0.3),
      barrierLabel: data ?? "Loading...",
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.2),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    ),
                  ),
                  vSizedBox0,
                  Text(
                    data ?? "Loading...",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void confirmDialog(
    BuildContext context, {
    String? title,
    String? description,
    Function()? onOk,
    Function()? onNo,
    Color? iconColor,
    String? svgIcon,
    Color? buttonYesColor,
    Color? buttonNoColor,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    vSizedBox2,
                    svgIcon != null
                        ? Container(
                            width: 80,
                            height: 80,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: iconColor?.withOpacity(0.2) ?? Colors.blue.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              svgIcon,
                            ),
                          )
                        : Container(),
                    vSizedBox2,
                    CustomText.ourText(
                      title ?? '',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    vSizedBox2,
                    CustomText.ourText(
                      description ?? '',
                      fontSize: 13,
                      color: Colors.grey,
                      textAlign: TextAlign.center,
                    ),
                    vSizedBox2,
                    onNo != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CustomButton.elevatedButton(
                                "Yes",
                                onOk ??
                                    () {
                                      back(context);
                                    },
                                width: 80,
                                color: buttonYesColor ?? Colors.blue,
                              ),
                              CustomButton.elevatedButton(
                                "No",
                                onNo,
                                width: 80,
                                color: buttonNoColor ?? Colors.blue,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              CustomButton.elevatedButton(
                                "Yes",
                                onOk ??
                                    () {
                                      back(context);
                                    },
                                color: buttonYesColor ?? Colors.blue,
                              ),
                              SizedBox(
                                width: kWidth,
                                child: TextButton(
                                  onPressed: () {
                                    back(context);
                                  },
                                  child: CustomText.ourText(
                                    "No Thanks",
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    vSizedBox2,
                  ],
                ),
              ),
            ),
          );
        });
  }
}
