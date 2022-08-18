class Evaluation {
  Evaluation({
    this.note,
    this.createdAt,
    this.bookingId,
    this.service,
  });

  double? note;
  DateTime? createdAt;
  int? bookingId;
  String? service;

  factory Evaluation.fromJson(Map<String, dynamic> json) => Evaluation(
        note: json["note"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        bookingId: json["bookingId"],
        service: json["service"],
      );

  Map<String, dynamic> toJson() => {
        "note": note,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "bookingId": bookingId,
        "service": service,
      };
}
