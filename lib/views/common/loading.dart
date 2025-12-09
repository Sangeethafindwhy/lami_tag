import 'package:flutter/material.dart';
import 'package:lami_tag/res/lami_colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(
        backgroundColor: LamiColors.black,
      ),

    );
  }
}

showLoadingPopUp({required BuildContext context}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Loading(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
    },
  );
}
