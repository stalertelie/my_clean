import 'booking_tarification.dart';

class Booking {
  Booking({
    this.localisation,
    this.user,
    this.choicesExtra,
    this.frequence,
    this.bookingTarifications,
  });

  String? localisation;
  String? user;
  String? choicesExtra;
  List<String>? frequence;
  List<BookingTarification>? bookingTarifications;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    localisation: json["localisation"] == null ? null : json["localisation"],
    user: json["user"] == null ? null : json["user"],
    choicesExtra: json["choicesExtra"] == null ? null : json["choicesExtra"],
    frequence: json["frequence"] == null ? null : List<String>.from(json["frequence"].map((x) => x)),
    bookingTarifications: json["bookingTarifications"] == null ? null : List<BookingTarification>.from(json["bookingTarifications"].map((x) => BookingTarification.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "localisation": localisation == null ? null : localisation,
    "user": user == null ? null : user,
    "choicesExtra": choicesExtra == null ? null : choicesExtra,
    "frequence": frequence == null ? null : List<dynamic>.from(frequence!.map((x) => x)),
    "bookingTarifications": bookingTarifications == null ? null : List<dynamic>.from(bookingTarifications!.map((x) => x.toJson())),
  };
}