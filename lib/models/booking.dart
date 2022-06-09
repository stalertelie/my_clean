import 'package:my_clean/models/entities/frequence.dart';
import 'package:my_clean/models/price_booking.dart';

import 'booking_tarification.dart';

class Booking {
  Booking({
    this.choicesExtra,
    this.localisation,
    this.user,
    this.createdAt,
    this.note,
    this.date,
    this.prices,
    this.priceTotal,
    this.gps,
    this.frequence,
    this.isMeubler,
  });

  List<String>? choicesExtra;
  String? localisation;
  String? user;
  DateTime? createdAt;
  String? note;
  DateTime? date;
  List<PriceBooking>? prices;
  int? priceTotal;
  String? gps;
  String? frequence;
  bool? isMeubler;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        choicesExtra: json["choicesExtra"] == null
            ? null
            : List<String>.from(json["choicesExtra"].map((x) => x)),
        localisation: json["localisation"] ?? null,
        user: json["user"] ?? null,
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        note: json["note"] ?? null,
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        prices: json["prices"] == null
            ? null
            : List<PriceBooking>.from(
                json["prices"].map((x) => PriceBooking.fromJson(x))),
        priceTotal: json["priceTotal"] ?? null,
        gps: json["gps"] ?? null,
        frequence: json["frequence"] == null ? null : json['frequence'],
        isMeubler: json["isMeubler"],
      );

  Map<String, dynamic> toJson() => {
        "choicesExtra": choicesExtra == null
            ? null
            : List<dynamic>.from(choicesExtra!.map((x) => x)),
        "localisation": localisation,
        "user": user,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "note": note,
        "date": date == null ? null : date!.toIso8601String(),
        "prices": prices == null
            ? null
            : List<dynamic>.from(prices!.map((x) => x.toJson())),
        "priceTotal": priceTotal,
        "gps": gps,
        "frequence": frequence,
        "isMeubler": isMeubler,
      };
}
