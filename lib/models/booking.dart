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
  List<dynamic>? frequence;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        choicesExtra: json["choicesExtra"] == null
            ? null
            : List<String>.from(json["choicesExtra"].map((x) => x)),
        localisation:
            json["localisation"] == null ? null : json["localisation"],
        user: json["user"] == null ? null : json["user"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        note: json["note"] == null ? null : json["note"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        prices: json["prices"] == null
            ? null
            : List<PriceBooking>.from(
                json["prices"].map((x) => PriceBooking.fromJson(x))),
        priceTotal: json["priceTotal"] == null ? null : json["priceTotal"],
        gps: json["gps"] == null ? null : json["gps"],
        frequence: json["frequence"] == null ? null : json["frequence"],
      );

  Map<String, dynamic> toJson() => {
        "choicesExtra": choicesExtra == null
            ? null
            : List<dynamic>.from(choicesExtra!.map((x) => x)),
        "localisation": localisation == null ? null : localisation,
        "user": user == null ? null : user,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "note": note == null ? null : note,
        "date": date == null ? null : date!.toIso8601String(),
        "prices": prices == null
            ? null
            : List<dynamic>.from(prices!.map((x) => x.toJson())),
        "priceTotal": priceTotal == null ? null : priceTotal,
        "gps": gps == null ? null : gps,
         "frequence": frequence == null ? null : List<dynamic>.from(frequence!.map((x) => x)),
      };
}
