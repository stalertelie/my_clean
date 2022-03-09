import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ioc/ioc.dart';
import 'package:my_clean/app_config.dart';
import 'package:my_clean/exceptions/booking_exception.dart';
import 'package:my_clean/exceptions/current-user-exception.dart';
import 'package:my_clean/models/booking.dart';
import 'package:my_clean/models/responses/current_user_response.dart';
import 'package:my_clean/models/responses/get-booking-response/get_booking_response.dart';
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
}
