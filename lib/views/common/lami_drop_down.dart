import 'package:flutter/material.dart';
import 'package:lami_tag/res/lami_colors.dart';

class LamiDropDown extends StatelessWidget {
  final String hintText;
  final String? selectedItem;
  final List<String> items;
  final String? Function(String?)? validator;
  final Function(String?)? onChanged;

  const LamiDropDown({
    super.key,
    required this.hintText,
    required this.validator,
    required this.selectedItem,
    required this.items,
    this.onChanged

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        value: selectedItem,
        validator: validator,
        onChanged: (String? newValue) {
          onChanged!(newValue);
        },
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down),
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: LamiColors.lighterGrey,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
        ),
      ),
    );
  }
}
