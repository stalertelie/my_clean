import 'package:flutter/material.dart';
import 'package:my_clean/constants/colors_constant.dart';

Widget CustomButton(
    {required BuildContext contextProp,
    required Function onPressedProp,
    required String textProp,
    bool disabledProp = false,
    double? padding = 30,
    BorderRadiusGeometry borderRadius = BorderRadius.zero}) {
  return Container(
      child: IgnorePointer(
          ignoring: disabledProp,
          child: Opacity(
            opacity: disabledProp ? 0.5 : 1,
            child: TextButton(
              onPressed: () {
                onPressedProp();
              },
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: padding!),
                  width: MediaQuery.of(contextProp).size.width,
                  decoration: BoxDecoration(
                      color: const Color(authBlue), borderRadius: borderRadius),
                  child: Text(textProp,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "SFPro",
                        fontSize: 20,
                        color: Colors.white,
                      ))),
            ),
          )));
}
