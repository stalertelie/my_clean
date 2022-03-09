import 'package:flutter/material.dart';
import 'package:my_clean/constants/colors_constant.dart';

Widget Loader({
  double size = 20.0,
  Color color = colorBlueLight,
  double strokeWidth = 3,
}) {
  return SizedBox(
    height: size,
    width: size,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),
      strokeWidth: strokeWidth,
    ),
  );
}
