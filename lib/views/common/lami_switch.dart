import 'package:flutter/cupertino.dart';

class LamiSwitch extends StatelessWidget {
  final bool value;
  final Function(bool)? onChanged;
  const LamiSwitch({super.key, required this.value, required this.onChanged});


  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
        value: value,
        onChanged: (newValue) {
          onChanged!(newValue);
        },
    );
  }
}
