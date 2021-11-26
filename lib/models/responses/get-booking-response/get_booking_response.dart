import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
import 'package:my_clean/models/entities/booking/booking.dart';

part 'get_booking_response.g.dart';

@JsonSerializable()
class GetBookingResponse {
  List<Booking>? hydraMember;

  GetBookingResponse({this.hydraMember});

  factory GetBookingResponse.fromJson(Map<String, dynamic> json) =>
      _$GetBookingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetBookingResponseToJson(this);
}
