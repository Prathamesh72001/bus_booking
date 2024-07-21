import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utility/colors.dart';


class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final String? fontFamily;
  const CommonText({
    Key? key,
    required this.text,
    this.fontSize = 16,
    this.color,
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow,
    this.decoration,
    this.fontFamily='poppins'
  }) : super(key: key);

  static TextStyle defaultStyle({
    required double fontSize,
    Color? color,
    TextDecoration? decoration,
    required FontWeight fontWeight,
  }) =>
      GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
          decoration: decoration,
          fontFamily: 'poppins'
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color ?? BrandColors.text,
          decoration: decoration,
          fontFamily: fontFamily
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
