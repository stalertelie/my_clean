import 'dart:convert';
import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';
// import 'package:build_runner/build_runner.dart';
import 'package:my_clean/models/entities/prices/prices.dart';
import 'package:my_clean/models/entities/frequence.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking {
  String? user;
  String? localisation;
  DateTime? date;
  List<Prices>? prices;
  int? priceTotal;
  bool? isMeubler;
  List<Frequence>? frequence;
  String? gps;
  String? note;
  int? id;

  Booking(
      {this.user,
      this.localisation,
      this.date,
      this.priceTotal,
      this.isMeubler,
      this.frequence,
      this.gps,
      this.prices,
      this.note,
      this.id});

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);

  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
