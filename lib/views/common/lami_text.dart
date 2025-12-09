import 'package:flutter/material.dart';
import 'package:lami_tag/res/lami_colors.dart';

class LamiText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextDecoration? textDecoration;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool softWrap;
  final double? height;

  const LamiText(
      {super.key,
      this.color,
      this.fontSize,
      this.letterSpacing,
      this.fontWeight,
      required this.text,
      this.textDecoration,
      this.maxLines = 3,
      this.textAlign,
      this.overflow,
      this.softWrap = false,
      this.height = 1.5,});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      style: TextStyle(
        fontSize: fontSize != null ? (fontSize! * 0.75) : 22,
        height: height,
        fontWeight: fontWeight ?? FontWeight.w700,
        color: color ?? LamiColors.white,
        decoration: textDecoration ?? TextDecoration.none,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
