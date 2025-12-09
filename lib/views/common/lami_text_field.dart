import 'package:flutter/material.dart';
import 'package:lami_tag/res/lami_colors.dart';

class LamiTextField extends StatefulWidget {
  final String hintText;
  final bool secureText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final bool enabled;

  const LamiTextField({super.key,
    required this.hintText,
    this.secureText = false,
    required this.controller,
    required this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text, this.enabled = true
  });

  @override
  State<LamiTextField> createState() => _LamiTextFieldState();
}

class _LamiTextFieldState extends State<LamiTextField> {

  bool obscureText = true;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      obscureText: widget.secureText ? obscureText : false,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: LamiColors.lighterGrey,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: LamiColors.lightestGrey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: LamiColors.lightestGrey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: LamiColors.lightestGrey,
          ),
        ),
        suffixIcon: (widget.secureText) ? IconButton(
          onPressed: (){
            setState(() {
              obscureText = !obscureText;
            });
          },
          icon: Icon(
              (obscureText) ? Icons.visibility : Icons.visibility_off
          ),
        ) :  const SizedBox.shrink(),
      ),
    );
  }
}
