import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton {
  static Widget elevatedButton(
    String title,
    Function() onPressed, {
    Color? titleColor,
    double? width,
    EdgeInsets? padding,
    double? height,
    double? fontSize,
    FontWeight? fontWeight,
    bool isFitted = false,
    bool isDisable = false,
    bool isBorder = false,
    Color? color,
    Color? borderColor,
    Color? foregroundColor,
    double borderRadius = 8.0,
  }) {
    return SizedBox(
      width: width,
      height: height ?? 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: color,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
              side: isBorder && !isDisable
                  ? BorderSide(color: borderColor ?? Colors.grey)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
        onPressed: isDisable ? null : onPressed,
        child: Center(
          child: isFitted
              ? FittedBox(
                  child: CustomText.ourText(
                    title,
                    fontSize: fontSize,
                    fontWeight: fontWeight ?? FontWeight.w400,
                    color: isDisable
                        ? Colors.grey.shade300
                        : titleColor ?? Colors.white,
                  ),
                )
              : CustomText.ourText(
                  title,
                  fontSize: fontSize,
                  fontWeight: fontWeight ?? FontWeight.w400,
                  color: isDisable
                      ? Colors.grey.shade300
                      : titleColor ?? Colors.white,
                ),
        ),
      ),
    );
  }

  static Widget textButton(
    String title,
    Function()? onPressed, {
    Color? titleColor,
    double? width,
    double? height,
    double? fontSize,
    FontWeight? fontWeight,
    bool isFitted = false,
    bool isDisable = false,
    bool isBorder = false,
    Color? color,
    double borderRadius = 8.0,
    Color? foregroundColor,
  }) {
    return SizedBox(
      width: width,
      height: height ?? 44,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              side: isBorder && !isDisable
                  ? BorderSide(color: color ?? Colors.grey)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(borderRadius)),
        ),
        onPressed: isDisable ? null : onPressed,
        child: Center(
          child: isFitted
              ? FittedBox(
                  child: CustomText.ourText(
                    title,
                    fontSize: fontSize,
                    fontWeight: fontWeight ?? FontWeight.w300,
                    color: isDisable
                        ? Colors.grey.shade300
                        : titleColor ?? Colors.black,
                  ),
                )
              : CustomText.ourText(
                  title,
                  fontSize: fontSize,
                  fontWeight: fontWeight ?? FontWeight.w300,
                  color: isDisable
                      ? Colors.grey.shade300
                      : titleColor ?? Colors.black,
                ),
        ),
      ),
    );
  }
}
