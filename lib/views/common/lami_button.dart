import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/views/common/lami_text.dart';

class LamiButton extends StatelessWidget {
  final Function() onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final double? width;
  final double? fontSize;
  final double? elevation;
  final String? icon;
  final EdgeInsets? padding;
  final Color borderColor;

  const LamiButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = LamiColors.red,
    this.textColor = LamiColors.white,
    this.width,
    this.fontSize = 16,
    this.icon,
    this.elevation = 0,
    this.padding,
    this.borderColor = LamiColors.lightestGrey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            side: BorderSide(
              color: borderColor,
            ),
            elevation: elevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: padding

          ),
          onPressed: onPressed,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              (icon != null) ? Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: SvgPicture.asset(
                  icon!,
                ),
              ) : const Center(),
                LamiText(
                  text: text,
                  color: textColor,
                  fontSize: fontSize,
                ),
              ],
          ),
      ),
    );
  }
}

class LamiSmallButton extends StatelessWidget {
  final Function() onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final double? width;
  final double? fontSize;
  final double? elevation;
  final String? icon;
  final EdgeInsets? padding;
  final Color borderColor;

  const LamiSmallButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = LamiColors.red,
    this.textColor = LamiColors.white,
    this.width,
    this.fontSize = 16,
    this.icon,
    this.elevation = 0,
    this.padding,
    this.borderColor = LamiColors.lightestGrey,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(
            color: borderColor,
          ),
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: padding

      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (icon != null) ? Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SvgPicture.asset(
              icon!,
            ),
          ) : const Center(),
          LamiText(
            text: text,
            color: textColor,
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }
}





