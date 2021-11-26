import 'package:my_clean/models/entities/services/services.dart';

class Price {
  Price(
      {this.id,
      this.type,
      this.priceId,
      this.label,
      this.initialNumber,
      this.price,
      this.priceOperator,
      this.operatorValue,
      this.quantity,
      this.service});

  String? id;
  String? type;
  int? priceId;
  String? label;
  int? initialNumber;
  int? price;
  String? priceOperator;
  int? operatorValue;
  int? quantity;
  Services? service;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
      id: json["@id"],
      type: json["@type"],
      priceId: json["id"],
      label: json["label"],
      initialNumber: json["initialNumber"],
      price: json["price"],
      priceOperator: json["operator"],
      operatorValue: json["operatorValue"],
      quantity: json["quantity"] == null ? null : json["-"],
      service:
          json['service'] == null ? null : Services.fromJson(json['service']));

  Map<String, dynamic> toJson() => {
        "@id": id,
        "@type": type == null ? null : type,
        "id": priceId == null ? null : priceId,
        "label": label == null ? null : label,
        "initialNumber": initialNumber == null ? null : initialNumber,
        "price": price == null ? null : price,
        "operator": priceOperator,
        "operatorValue": operatorValue,
        "quantity": quantity == null ? null : quantity,
        "service": service == null ? null : service
      };
}
