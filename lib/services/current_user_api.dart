// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ioc/ioc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:my_clean/app_config.dart';
import 'package:my_clean/exceptions/current-user-exception.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/services/localization.dart';
import 'package:my_clean/services/safe_secure_storage.dart';

class CurrentUserApi {
  final AppConfig config;
  final http.Client client;
  final String endpoint = '/users';
  final storage = Ioc().use<SafeSecureStorage>('secureStorage');

  CurrentUserApi({required this.config, required this.client});

  Future<User> getCurrentUser(String id) async {
    final tokenPref = await storage.read(key: 'token');
    final String url = config.apiBaseUrl + endpoint + '/$id';
    final response = await client.get(Uri.parse(url), headers: {
      // HttpHeaders.acceptHeader: 'application/ld+json',
      // HttpHeaders.authorizationHeader: 'Bearer $tokenPref',
      // HttpHeaders.contentTypeHeader: 'application/ld+json'
    });

    Map<String, dynamic> responseMap = jsonDecode(response.body);

    final currentUserResponse = User.fromJson(responseMap);
    print("status ${response.statusCode}");
    if (response.statusCode != 200) {
      throw CurrentUserException(
          AppLocalizations.current.somethingIsWrongErrorLabel);
    }
    return currentUserResponse;
  }

  Future<User> updateCurrentUserInfo(User userInfo, String id) async {
    final tokenPref = await storage.read(key: 'token');
    final url = config.apiBaseUrl + endpoint + '/$id';
    final body = jsonEncode({
      'email': userInfo.email,
      'nom': userInfo.nom,
      'prenoms': userInfo.prenoms,
      'phone': userInfo.phone,
    });
    final response = await client.put(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          // HttpHeaders.authorizationHeader: 'Bearer $tokenPref'
        },
        body: body);

    Map<String, dynamic> responseMap = jsonDecode(response.body);
    final currentUserResponse = User.fromJson(responseMap);

    if (response.statusCode != 200) {
      throw CurrentUserException(
          AppLocalizations.current.somethingIsWrongErrorLabel);
    }

    return currentUserResponse;
  }

  Future<bool> updatePassword(String oldPassword, String newPassword) async {
    final tokenPref = await storage.read(key: 'token');
    Map<String, dynamic> payload = Jwt.parseJwt(tokenPref);
    final id = payload['id'];
    print("id $id");

    const changePasswordEndpoint = "/change_password/change";

    final url = config.apiBaseUrl + changePasswordEndpoint;
    final body = jsonEncode({
      'password': oldPassword,
      'newpassword': newPassword,
      'user': "/users/$id",
    });
    print(body);
    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body);

    print(response.statusCode);

    if (response.statusCode != 200) {
      throw CurrentUserException(
          AppLocalizations.current.somethingIsWrongErrorLabel);
    }

    return true;
  }

  Future<bool> sendVerificationCode(String phone) async {
    const sendVerificationEndpoint = "/forgot_password/forgot";

    final url = config.apiBaseUrl + sendVerificationEndpoint;
    final body = jsonEncode({
      'phone': phone,
    });

    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body);
    print(response.statusCode);
    if (response.statusCode != 201) {
      throw CurrentUserException(
          AppLocalizations.current.somethingIsWrongErrorLabel);
    }

    return true;
  }

  Future<bool> verifyCodeAndUpdatePassword(
      String phone, String code, String newPassword) async {
    const sendVerificationEndpoint = "/password_reset/reset";

    final url = config.apiBaseUrl + sendVerificationEndpoint;
    final body = jsonEncode({
      'phone': phone,
      'code': code,
      'newpassword': newPassword,
    });

    final response = await client.post(Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: body);

    print(response.statusCode);

    if (response.statusCode != 200) {
      throw CurrentUserException(
          AppLocalizations.current.somethingIsWrongErrorLabel);
    }

    return true;
  }
}
