import 'package:my_clean/models/tarification.dart';

class TarificationObject {
  TarificationObject({
    this.tarifications,
    this.quantity,
  });

  Tarification? tarifications;
  int? quantity;

  factory TarificationObject.fromJson(Map<String, dynamic> json) => TarificationObject(
    tarifications: json["tarifications"] == null ? null : Tarification.fromJson(json["tarifications"]),
    quantity: json["quantity"] == null ? null : json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "tarifications": tarifications == null ? null : tarifications!.toJson(),
    "quantity": quantity == null ? null : quantity,
  };
}