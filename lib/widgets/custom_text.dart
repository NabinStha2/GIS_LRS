import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText {
  static Text ourText(
    String? data, {
    Color? color,
    FontWeight? fontWeight,
    TextAlign? textAlign = TextAlign.start,
    double? fontSize = 16,
    int? maxLines = 2,
    TextDecoration? textDecoration,
    bool? isFontFamily = true,
  }) =>
      Text(
        data ?? '',
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          decoration: textDecoration ?? TextDecoration.none,
          fontSize: fontSize,
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontWeight: fontWeight ?? FontWeight.normal,
          color: color ?? Colors.black,
        ),
      );
}
