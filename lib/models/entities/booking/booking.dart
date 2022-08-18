import 'dart:convert';
import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
// import 'package:build_runner/build_runner.dart';
import 'package:my_clean/models/entities/prices/prices.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking {
  String? user;
  String? code;
  String? localisation;
  DateTime? date;
  DateTime? createdAt;
  bool? isClosed;
  List<Prices>? prices;
  int? priceTotal;
  bool? isMeubler;
  String? frequence;
  String? gps;
  String? note;
  int? id;
  bool? hasEvaluation;

  Booking(
      {this.user,
      this.localisation,
      this.date,
      this.createdAt,
      this.priceTotal,
      this.isMeubler,
      this.frequence,
      this.gps,
      this.prices,
      this.note,
      this.isClosed,
      this.code,
      this.hasEvaluation,
      this.id});

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
