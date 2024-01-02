import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.validator,
    this.maxLines,
  });

  final TextEditingController controller;
  final String hintText;
  final String labelText;
  int? maxLines = null;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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