import 'package:flutter/material.dart';

Widget CustomDialog({
  required BuildContext contextProp,
  String? titleProp,
  required String messageProp,
  String? positiveButtonTextProp,
  bool? showNegativeButtonProp,
  String? negativeButtonTextProp,
  Function? positiveButtonOnPressProp,
  Function? negativeButtonOnPressProp,
  Icon? iconProp,
}) {
  return AlertDialog(
    title: Text(titleProp ?? 'My clean'),
    content: Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        iconProp != null
            ? Container(padding: EdgeInsets.only(bottom: 15), child: iconProp)
            : Container(),
        Text(messageProp),
      ],
    )),
    actions: <Widget>[
      showNegativeButtonProp != null && showNegativeButtonProp
          ? TextButton(
              child: Text(negativeButtonTextProp ?? 'Annuler'),
              onPressed: () {
                negativeButtonOnPressProp ?? Navigator.of(contextProp).pop();
              },
            )
          : Container(),
      TextButton(
        child: Text(positiveButtonTextProp ?? 'Ok'),
        onPressed: () {
          positiveButtonOnPressProp ?? Navigator.of(contextProp).pop();
        },
      ),
    ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
  );
}
