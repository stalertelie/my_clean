import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_clean/app_config.dart';
import 'package:my_clean/exceptions/booking_exception.dart';
import 'package:my_clean/models/booking.dart';
import 'package:my_clean/models/responses/get-booking-response/get_booking_response.dart';

class BookingApi {
  final AppConfig config;
  final http.Client client;
  final String endpoint = '/bookings';

  BookingApi({required this.config, required this.client});

  Future<String> getAppVersion() async => await config.version;

  Future<GetBookingResponse> getCommandList(
      {required String id, int? page = 1}) async {
    final String url = config.apiBaseUrl + endpoint + '?user=$id&page=$page';
    print(url);
    final response = await client.get(Uri.parse(url), headers: {
      // HttpHeaders.acceptHeader: 'application/ld+json',
      HttpHeaders.contentTypeHeader: 'application/ld+json'
    });

    Map<String, dynamic> responseMap = jsonDecode(response.body);
    print(response.body);

    final bookingResponse = GetBookingResponse.fromJson(responseMap);

    if (response.statusCode != 200) {
      throw const BookingException("Quelque chose s'est mal passé");
    }
    return bookingResponse;
  }
}
