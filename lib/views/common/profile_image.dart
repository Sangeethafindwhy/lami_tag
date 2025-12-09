import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/res/lami_images.dart';
import 'package:lami_tag/utils/responsive_height_width.dart';

class ProfileImage extends StatelessWidget {
  final String image;
  final double? size;

  const ProfileImage({super.key, this.image = '', this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ((size ?? displayWidth(context)) * 0.25),
      width: ((size ?? displayWidth(context)) * 0.25),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.red, width: 2)),
      child: (image.isNotEmpty)
          ? (image.contains('http'))
              ? CircleAvatar(
                  backgroundImage: NetworkImage(image),
                  onBackgroundImageError: (object, error) {},
                )
              : CircleAvatar(
                  backgroundImage: FileImage(
                    File(image),
                  ),
                )
          : Image.asset(
              LamiImages.profile,
            ),
    );
  }
}

class EquineProfileImage extends StatelessWidget {
  final String image;
  final double? size;

  const EquineProfileImage({super.key, required this.image, this.size});

  @override
  Widget build(BuildContext context) {
    double finalSize = size ?? displayWidth(context) * 0.25;
    return Container(
      height: finalSize,
      width: finalSize,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: LamiColors.red,
          image: image.isNotEmpty
              ? DecorationImage(image: getImageWidget(image), fit: BoxFit.cover)
              : DecorationImage(
                  image: getImageWidget(image),
                )),
    );
  }

  ImageProvider getImageWidget(String image) {
    if (image.isNotEmpty) {
      if (image.contains('https')) {
        return NetworkImage(
          image,
        );
      } else {
        return FileImage(
          File(image),
        );
      }
    } else {
      return const AssetImage(
        LamiImages.horseProfile,
      );
    }
  }
}
