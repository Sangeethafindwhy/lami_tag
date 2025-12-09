import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lami_tag/res/lami_colors.dart';
import 'package:lami_tag/views/common/lami_text.dart';

Future<int?> showSelectionSheet(
    BuildContext context, List<String> options, List<IconData> icons) async {
  return await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            options.length,
            (index) => ListTile(
              leading: Icon(icons[index]),
              title: LamiText(
                text: options[index],
                color: LamiColors.black,
                fontSize: 16,
              ),
              onTap: () {
                Navigator.of(context).pop(index);
              },
            ),
          ),
        );
      });
}

// showImageSourceActionSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (context) {
//       return SafeArea(
//         child: Wrap(
//           children: <Widget>[
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const LamiText(text: 'Gallery'),
//               onTap: () {
//                 Navigator.of(context).pop(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const LamiText(text: 'Camera'),
//               onTap: () {
//                 Navigator.of(context).pop(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
