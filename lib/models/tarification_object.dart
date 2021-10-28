import 'package:my_clean/models/price.dart';

class TarificationObject {
  TarificationObject({
    this.tarifications,
    this.quantity,
  });

  Price? tarifications;
  int? quantity;

  factory TarificationObject.fromJson(Map<String, dynamic> json) => TarificationObject(
    tarifications: json["tarifications"] == null ? null : Price.fromJson(json["tarifications"]),
    quantity: json["quantity"] == null ? null : json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "tarifications": tarifications == null ? null : tarifications!.toJson(),
    "quantity": quantity == null ? null : quantity,
  };
}