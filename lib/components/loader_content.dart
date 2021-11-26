import 'package:flutter/material.dart';

import 'loader.dart';

Widget LoaderContent() {
  return Container(
    alignment: Alignment.center,
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Loader(),
        const Padding(
          padding: EdgeInsets.only(top: 15),
          child: Text('Loading...')
        )
      ],
    )
  );
}
