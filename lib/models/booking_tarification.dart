class BookingTarification {
  BookingTarification({
    this.tarification,
    this.quantity,
  });

  String? tarification;
  int? quantity;

  factory BookingTarification.fromJson(Map<String, dynamic> json) => BookingTarification(
    tarification: json["tarification"] == null ? null : json["tarification"],
    quantity: json["quantity"] == null ? null : json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "tarification": tarification == null ? null : tarification,
    "quantity": quantity == null ? null : quantity,
  };
}
