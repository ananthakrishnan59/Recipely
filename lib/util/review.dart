import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';


class ReviewTextField extends StatefulWidget {
  final void Function()? onTap;
  final TextEditingController? controller;
  const ReviewTextField({
    super.key,
    this.onTap,
    this.controller,
  });

  @override
  State<ReviewTextField> createState() => _ReviewTextFieldState();
}

class _ReviewTextFieldState extends State<ReviewTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (value) {},
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: widget.onTap,
          child: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(FeatherIcons.send),
          ),
        ),
        suffixIconColor: Colors.grey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        hintText: 'Add a review...',
        hintStyle: const TextStyle(
          color: Color(0x66000000),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
