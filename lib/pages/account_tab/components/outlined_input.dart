import 'package:flutter/material.dart';

class OutlinedInput extends StatelessWidget {
  const OutlinedInput({
    Key? key,
   this.initialValue,
    this.labelText,
    required this.hintText,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixIcon,
    required this.controller,
    this.labelStyle
  }) : super(key: key);

  final String? initialValue;
  final String? labelText;
  final TextStyle? labelStyle;
  final String hintText;
  final bool readOnly;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      readOnly: readOnly,
      obscureText: obscureText,
      style: TextStyle(fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.87)),
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color.fromRGBO(25, 25, 25, 0.32),
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color(0xFF6C92EB),
              )),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Color.fromRGBO(25, 25, 25, 0.32),
              )),
          hintText: hintText,
          labelText: labelText,
          labelStyle:
          labelStyle ?? TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.4),),
    );
  }
}
