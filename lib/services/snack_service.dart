import 'package:flutter/material.dart';

class SnackService{


  showSnackBar({required BuildContext context, required String message}){
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}