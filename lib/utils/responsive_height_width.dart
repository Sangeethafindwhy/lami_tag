import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  return MediaQuery.sizeOf(context);
}

double displayHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height;
}

double displayWidth(BuildContext context) {
  return MediaQuery.sizeOf(context).width;
}
