// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_booking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBookingResponse _$GetBookingResponseFromJson(Map<String, dynamic> json) =>
    GetBookingResponse(
      hydraMember: json['hydra:member'] != null
          ? (json['hydra:member'] as List)
              .map((e) => Booking.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );

Map<String, dynamic> _$GetBookingResponseToJson(GetBookingResponse instance) =>
    <String, dynamic>{
      'hydraMember': instance.hydraMember,
    };
