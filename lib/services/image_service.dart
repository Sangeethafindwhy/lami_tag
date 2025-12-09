import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageService{

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage({ImageSource imageSource = ImageSource.camera}) async {
    final pickedFile = await _picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }else{
      return null;
      //
    }
  }
}