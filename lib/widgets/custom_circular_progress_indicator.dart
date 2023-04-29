import 'package:flutter/material.dart';

import '../core/app/dimensions.dart';
import 'custom_text.dart';

class CustomCircularProgressIndicatorWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double? value;
  final double? strokeWidth;
  final String? title;
  const CustomCircularProgressIndicatorWidget({
    Key? key,
    this.width,
    this.height,
    this.value,
    this.strokeWidth,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width ?? 25,
            height: height ?? 25,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: strokeWidth ?? 2,
            ),
          ),
          vSizedBox1,
          CustomText.ourText(
            title ?? "Loading...",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
