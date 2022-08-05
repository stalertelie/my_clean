// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prices _$PricesFromJson(Map<String, dynamic> json) => Prices(
      quantity: json['quantity'],
      tarification:
          Price.fromJson(json['tarification'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PricesToJson(Prices instance) => <String, dynamic>{
      'tarification': instance.tarification,
    };
