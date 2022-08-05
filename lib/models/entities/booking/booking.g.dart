// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
    user: json['user'] != null ? json['user']['nom'] as String : null,
    localisation:
        json['localisation'] != null ? json['localisation'] as String : null,
    date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : null,
    priceTotal: json['priceTotal'] != null ? json['priceTotal'] as int : null,
    isMeubler: json['isMeubler'] != null ? json['isMeubler'] as bool : null,
    frequence: json['frequence'] != null ? json['frequence'] as String : null,
    gps: json['gps'] != null ? json['gps'] as String : null,
    code: json['code'] != null ? json['code'] as String : null,
    prices: json['prices'] != null
        ? (json['prices'] as List)
            .map((e) => Prices.fromJson(e as Map<String, dynamic>))
            .toList()
        : null,
    note: json['note'] != null ? json['note'] as String : null,
    isClosed: json['isClosed'] != null ? json['isClosed'] as bool : null,
    id: json['id'] != null ? json['id'] as int : null);

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'user': instance.user,
      'localisation': instance.localisation,
      'date': instance.date!.toIso8601String(),
      'prices': instance.prices,
      'priceTotal': instance.priceTotal,
      'isMeubler': instance.isMeubler,
      'frequence': instance.frequence,
      'gps': instance.gps,
      'note': instance.note,
      'id': instance.id,
    };
