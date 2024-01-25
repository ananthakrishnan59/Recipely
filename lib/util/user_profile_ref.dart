import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

listTile(String title, {Color? textcolor, Widget? iconbutton,void Function()? onTap }) {
  return InkWell(onTap:onTap ,
    child: ListTile(
      title: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.ubuntu(
                textStyle:
                    TextStyle(color: textcolor ?? Colors.black, fontSize: 18)),
          ),
          if (iconbutton != null)
            Align(
              child: iconbutton,
            ),
        ],
      ),
    ),
  );
}

textformfieldUserEdit(String labelText, TextEditingController Controller,
    RegExp regex, String validationmessage, String regexmessage,
    {bool? obscuretext = false}) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    obscureText: obscuretext!,
    controller: Controller,
    validator: (value) {
      if (!regex.hasMatch(value!)) {
        return regexmessage;
      } else if (value.isEmpty) {
        return validationmessage;
      }
      return null;
    },
    style: const TextStyle(color: Colors.black),
    decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.teal)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 1, 109, 98))),
        labelStyle: const TextStyle(color: Color.fromARGB(255, 16, 16, 16)),
        labelText: labelText),
  );
}
