import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
// import 'package:build_runner/build_runner.dart';
import 'package:my_clean/models/entities/price/price.dart';

part 'prices.g.dart';

@JsonSerializable()
class Prices {
  Price tarification;
  int? quantity;

  Prices({required this.tarification, this.quantity});

  factory Prices.fromJson(Map<String, dynamic> json) => _$PricesFromJson(json);

  Map<String, dynamic> toJson() => _$PricesToJson(this);
}
