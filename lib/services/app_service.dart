import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:velocity_x/velocity_x.dart';

class AppServices {
  String? lang;

  String? playerId;

  GlobalKey? drawerKey;

  String? servicePassedId;

  GlobalKey<ScaffoldMessengerState>? messengerGlobalKey;

  User? userData;

  void setPlayerId(String id) {
    playerId = id;
  }

  void setUSer(User user) {
    userData = user;
  }

  clear() {
    userData = null;
  }

  void setLang(String lang) {
    this.lang = lang;
  }

  void setServicePassedId(String? id) {
    this.servicePassedId = id;
  }

  void setKey(GlobalKey key) {
    drawerKey = key;
  }

  void setMessengerGlobalKey(GlobalKey<ScaffoldMessengerState> key) {
    messengerGlobalKey = key;
  }

  void showSnackbarWithState(Loading? loading) {
    print(messengerGlobalKey);
    messengerGlobalKey!.currentState?.clearSnackBars();
    if (loading!.message != null) {
      messengerGlobalKey!.currentState?.showSnackBar(SnackBar(
        duration: loading.loading == true
            ? const Duration(minutes: 1)
            : const Duration(seconds: 5),
        content: loading.loading == true
            ? Row(
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 50,
                  ),
                  Flexible(child: Text(loading.message ?? ""))
                ],
              )
            : !(loading.hasError ?? true)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                          child: (loading.message ?? "")
                              .text
                              .green400
                              .semiBold
                              .make())
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                          child: (loading.message ?? "").text.red400.make()),
                    ],
                  ),
      ));
    }
  }

  AppServices() {
    UtilsFonction.getData(AppConstant.USER_INFO).then((value) {
      if (value != null) {
        userData = User.fromJson(jsonDecode(value));
      }
    });
  }

  /*void setUpUSer(Customer login) {
    UtilsFonction.saveData(AppConstant.USER_INFO, json.encode(login))
        .then((value) {
      this.loginData = login;
    });
  }*/

}
