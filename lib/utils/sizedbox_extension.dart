import 'package:flutter/material.dart' show SizedBox;

extension PaddingHeight on num {
  SizedBox get ph => SizedBox(height: toDouble());
  SizedBox get pw => SizedBox(width: toDouble());
}
