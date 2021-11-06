import 'package:flutter/material.dart';
import 'package:my_clean/constants/colors_constant.dart';

Widget CustomButton({
  required BuildContext contextProp,
  required Function onPressedProp,
  required String textProp,
  bool disabledProp = false,
}) {
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
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  width: MediaQuery.of(contextProp).size.width,
                  decoration: BoxDecoration(
                      color: const Color(authBlue),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(textProp,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "SFPro",
                        fontSize: 17,
                        color: Colors.white,
                      ))),
            ),
          )));
}
