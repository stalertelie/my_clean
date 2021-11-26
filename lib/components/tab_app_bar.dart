import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar TabAppBar(
    {required String titleProp,
    bool showBackButton = false,
    List<Widget>? actionsProp,
    Color? backgroundColor,
    required BuildContext context,
    Color? backButtonColor,
    Color? titleColor,
    double? titleFontSize,
    bool centerTitle = false}) {
  return AppBar(
    title: Padding(
      padding: EdgeInsets.only(left: showBackButton ? 0 : 14),
      child: Text(titleProp,
          style: TextStyle(
              fontFamily: "SFPro",
              fontSize: titleFontSize ?? 20,
              height: 23 / 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
              color: titleColor ?? const Color.fromRGBO(0, 0, 0, 0.87))),
    ),
    backgroundColor: backgroundColor ?? Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    elevation: 0.0,
    key: const Key('app-bar'),
    actions: actionsProp,
    leading: showBackButton
        ? TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 30,
              color: Colors.black,
            ))
        : null,
    centerTitle: centerTitle,
  );
}
