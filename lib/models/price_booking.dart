class PriceBooking {
  PriceBooking({
    this.tarification,
    this.quantity,
  });

  String? tarification;
  int? quantity;

  factory PriceBooking.fromJson(Map<String, dynamic> json) => PriceBooking(
    tarification: json["tarification"] == null ? null : json["tarification"],
    quantity: json["quantity"] == null ? null : json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "tarification": tarification == null ? null : tarification,
    "quantity": quantity == null ? null : quantity,
  };
}
