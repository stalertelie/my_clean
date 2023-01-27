// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget InputField(
    {required String initialValue,
    String? labelText,
    String? label,
    required TextInputType inputType,
    dynamic onChanged,
    bool obscureText = false,
    String? valueToCheck,
    bool showErrorMessage = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool autofocus = false,
    int? maxLines = 1,
    bool enabled = true,
    Color? labelColor = Colors.black,
    Color? borderColor,
    double inputRadius = 5.0}) {
  return Column(
    children: <Widget>[
      label != null
          ? Container(
              margin: const EdgeInsets.only(bottom: 5),
              alignment: Alignment.topLeft,
              child: Text(
                label,
                style: TextStyle(fontSize: 17.0, color: labelColor),
              ),
            )
          : Container(),
      TextFormField(
        keyboardType: inputType,
        enabled: enabled,
        maxLines: maxLines,
        autofocus: autofocus,
        obscureText: obscureText,
        initialValue: initialValue,
        onChanged: onChanged,
        validator: (value) {
          if (value!.isEmpty && showErrorMessage == true) {
            return 'Requis';
          }
          return null;
        },
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: prefixIcon ?? null,
          suffixIcon: suffixIcon ?? null,
          hintText: labelText,
          filled: true,
          focusedBorder: OutlineInputBorder(
              borderSide: borderColor != null
                  ? BorderSide(color: borderColor)
                  : BorderSide.none),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
          labelStyle: const TextStyle(fontSize: 16.0),
          border: OutlineInputBorder(
              borderSide: borderColor != null
                  ? BorderSide(
                      color: borderColor,
                    )
                  : BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(inputRadius))),
        ),
      ),
    ],
  );
}
