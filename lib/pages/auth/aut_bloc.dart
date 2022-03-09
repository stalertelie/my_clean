import 'dart:convert';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:ioc/ioc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:my_clean/constants/app_constant.dart';
import 'package:my_clean/constants/message_constant.dart';
import 'package:my_clean/constants/url_constant.dart';
import 'package:my_clean/models/base_bloc.dart';
import 'package:my_clean/models/loading.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/services/app_service.dart';
import 'package:my_clean/services/safe_secure_storage.dart';
import 'package:my_clean/utils/request_extension.dart';
import 'package:my_clean/utils/utils_fonction.dart';
import 'package:rxdart/rxdart.dart';
import 'package:my_clean/extensions/extensions.dart';

class AuthBloc extends BaseBloc {
  Stream<User> get CustomElementRegistryStream =>
      _CustomElementRegistrySubject.stream;
  final _CustomElementRegistrySubject = BehaviorSubject<User>();

  BehaviorSubject<User> get CustomElementRegistrySubject =>
      _CustomElementRegistrySubject;
  final SafeSecureStorage storage = Ioc().use('secureStorage');

  createUser(User c) {
    RequestExtension<User> requestExtension = RequestExtension();

    loadingSubject.add(Loading(loading: true, message: "Inscription en cours"));

    GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);

    Future<dynamic> response =
        requestExtension.post(UrlConstant.url_users, jsonEncode(c));
    response.then((value) {
      User user = value as User;
      UtilsFonction.saveData(AppConstant.USER_INFO, json.encode(user))
          .then((value) {
        loadingSubject.add(Loading(
            message: MessageConstant.signupok,
            hasError: false,
            loading: false,
            data: user));
      });
    }).catchError((error) {
      print(error.toString());
      loadingSubject.add(Loading(
          message: error.toString().removeExeptionWord(),
          hasError: true,
          loading: false));
      GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);
    });
  }

  logUser(User c) {
    RequestExtension<User> requestExtension = RequestExtension();

    loadingSubject.add(Loading(loading: true, message: "Connexion en cours"));

    GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);

    Future<dynamic> response =
        requestExtension.post("authentication_token", jsonEncode(c));

    response.then((value) async {
      User user = value as User;
      getUserByToken(user.token!);
      await storage.write(key: 'token', value: user.token!);
    }).catchError((error) {
      print(error);
      loadingSubject.add(Loading(
          message: error.toString().removeExeptionWord(),
          hasError: true,
          loading: false));
      GetIt.I<AppServices>().showSnackbarWithState(loadingSubject.value);
    });
  }

  getUserByToken(String token) {
    RequestExtension<User> requestExtension = RequestExtension();

    Map<String, dynamic> payload = Jwt.parseJwt(token);

    Future<dynamic> response =
        requestExtension.get(UrlConstant.url_users + "/${payload['id']}");

    response.then((value) {
      User user = value as User;
      UtilsFonction.saveData(AppConstant.USER_INFO, json.encode(user))
          .then((value) {
        //_loadingSubject.add(Loading(loading: false,hasError: false,message: "Connecion ok"),);
        loadingSubject.add(Loading(
            message: MessageConstant.loginok,
            hasError: false,
            loading: false,
            data: user));
      });
    }).catchError((error) {
      print(error);
      loadingSubject.add(Loading(
          message: error.toString().removeExeptionWord(),
          hasError: true,
          loading: false));
    });
  }
}
