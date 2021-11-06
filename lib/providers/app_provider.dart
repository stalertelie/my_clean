import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_clean/models/user.dart';

class AppProvider extends ChangeNotifier {

  User? login;



 // String locale;

  updateConnectedUSer(dynamic c){
    login = c;
    Future.delayed(const Duration(milliseconds: 500),(){
      notifyListeners();
    });
  }



  /*updateLocal(String locale,String localCode,BuildContext context){
    this.locale = locale;
    EasyLocalization.of(context).locale = Locale(locale,localCode);
    notifyListeners();
    /*UtilsFonction.saveData('local', locale).then((value) {
      UtilsFonction.saveData('localCode', localCode);
    });*/
  }*/


  void signOut(){
    login = null;
    notifyListeners();
  }

}