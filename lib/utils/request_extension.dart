import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_clean/models/Status.dart';
import 'package:my_clean/models/booking.dart';
import 'package:my_clean/models/data_response.dart';
import 'package:my_clean/models/user.dart';
import 'package:my_clean/services/localization.dart';

class RequestExtension<T> {
  //static RequestExtension _instance = new RequestExtension();

  //factory RequestExtension() => _instance;
  /*static const String _urlEndpoint =
      'http://api.maison-dakoula.novate-media.com/';
  static const String _urlEndpointSimple =
      'http://api.maison-dakoula.novate-media.com';*/

  static const String _urlEndpoint = 'http://myclean.novate-media.com/';
  static const String _urlEndpointSimple = 'http://myclean.novate-media.com';

  //static const  String _urlEndpoint = 'http://10.200.1.66:8080/';

  Future<dynamic> post(String url, dynamic data) async {
    print(data);
    final response = await http.post(Uri.parse(_urlEndpoint + url),
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          HttpHeaders.acceptLanguageHeader: AppLocalizations.current.localeName
        },
        body: data);
    print("=====URL OF CALL ===== ${_urlEndpoint + url}");
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      debugPrint(response.body.toString());
      switch (T) {
        case User:
          return User.fromJson(json.decode(response.body.toString()));
        case Booking:
          return true;
        default:
          return DataResponse<T>.fromJson(
              json.decode(response.body.toString()));
      }
    } else {
      // If that call was not successful, throw an error.
      String message = "";
      if (jsonDecode(response.body)['hydra:description'] != null) {
        message = jsonDecode(response.body)['hydra:description'];
      } else {
        if (jsonDecode(response.body)['message'] != null) {
          message = jsonDecode(response.body)['message'];
        } else {
          message = response.reasonPhrase!;
        }
      }
      print(response.reasonPhrase);
      print(response.body);
      print(message);
      throw Exception(message);
    }
  }

  Future<dynamic> put(String url, dynamic data) async {
    final response = await http.put(Uri.parse(_urlEndpointSimple + url),
        headers: {
          "Content-Type": "application/ld+json; charset=utf-8",
          HttpHeaders.acceptLanguageHeader: AppLocalizations.current.localeName
        },
        body: data);

    print(data);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      debugPrint(response.body.toString());
      switch (T) {
        default:
          return DataResponse<T>.fromJson(
              json.decode(response.body.toString()));
      }
    } else {
      // If that call was not successful, throw an error.
      String message = "";
      if (jsonDecode(response.body)['hydra:description'] != null) {
        message = jsonDecode(response.body)['hydra:description'];
      } else {
        message = response.reasonPhrase!;
      }
      print(response.reasonPhrase);
      print(response.body);
      print(message);
      throw Exception(message);
    }
  }

  Future<dynamic> get(String url) async {
    print(_urlEndpoint + url);
    final response = await http.get(Uri.parse(_urlEndpoint + url), headers: {
      "Content-Type": "application/json; charset=utf-8",
      HttpHeaders.acceptLanguageHeader: AppLocalizations.current.localeName
    });
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      print(response.body.toString());
      switch (T) {
        case Status:
          return Status.fromJson(json.decode(response.body.toString()));
        case User:
          return User.fromJson(json.decode(response.body.toString()));
        case Booking:
          return Booking.fromJson(json.decode(response.body.toString()));
        default:
          return DataResponse<T>.fromJson(
              json.decode(response.body.toString()));
      }
    } else {
      // If that call was not successful, throw an error.
      print(response.statusCode);
      throw Exception('Failed to load post ' + response.reasonPhrase!);
    }
  }

  Future<dynamic> postWithNatif(String url, dynamic data) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse(_urlEndpoint + url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(data));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      debugPrint('yyyyyyyyyy ' + reply);
      httpClient.close();
      return DataResponse<T>.fromJson(json.decode(reply));
    } else {
      debugPrint(response.statusCode.toString());
      // If that call was not successful, throw an error.
      throw Exception(response.reasonPhrase);
    }

    //return reply;
  }
}
