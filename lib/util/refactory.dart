// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.labelText,
      this.validator,
      this.maxLines, this.keyboardType,
       
      });

  final TextEditingController controller;
  final String hintText;
  final String labelText;
    final TextInputType? keyboardType;
  int? maxLines = null;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
        labelText: labelText,
      ),
    );
  }
}
