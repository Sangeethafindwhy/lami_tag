import 'package:flutter/material.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/utils/responsive_height_width.dart';

class DefaultBackground extends StatelessWidget {
  final Widget child;
  final double? height;
  const DefaultBackground({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LamiColors.black,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  LamiIcons.horseIcon,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 40),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: displayWidth(context),
                    height: height,
                    decoration: BoxDecoration(
                        color: LamiColors.white,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: child
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
