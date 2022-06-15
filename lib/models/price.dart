import 'package:my_clean/models/tarification_intervalle.dart';

class Price {
  Price(
      {this.id,
      this.type,
      this.priceId,
      this.label,
      this.initialNumber,
      this.price,
      this.priceAbonment,
      this.priceOperator,
      this.operatorValue,
      this.quantity,
      this.min,
      this.max,
      this.tarificationIntervalles,
      this.service});

  String? id;
  String? type;
  int? priceId;
  String? label;
  int? initialNumber;
  int? price;
  int? priceAbonment;
  String? priceOperator;
  int? operatorValue;
  int? quantity;
  String? service; //HERE
  int? min;
  int? max;
  List<TarificationIntervalle>? tarificationIntervalles;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        id: json["@id"],
        type: json["@type"],
        priceId: json["id"],
        label: json["label"],
        initialNumber: json["initialNumber"],
        price: json["price"],
        priceAbonment: json["priceAbonment"],
        priceOperator: json["operator"],
        operatorValue: json["operatorValue"],
        min: json["min"],
        max: json["max"],
        tarificationIntervalles: json["tarificationIntervalles"] == null
            ? null
            : List<TarificationIntervalle>.from(json["tarificationIntervalles"]
                .map((x) => TarificationIntervalle.fromJson(x))),
        quantity: json["quantity"] == null ? null : json["-"],
      );

  Map<String, dynamic> toJson() => {
        "@id": id,
        "@type": type == null ? null : type,
        "id": priceId == null ? null : priceId,
        "label": label == null ? null : label,
        "initialNumber": initialNumber == null ? null : initialNumber,
        "price": price == null ? null : price,
        "priceAbonment": priceAbonment == null ? null : priceAbonment,
        "operator": priceOperator,
        "operatorValue": operatorValue,
        "min": min,
        "max": max,
        "quantity": quantity == null ? null : quantity,
        "tarificationIntervalles": tarificationIntervalles == null
            ? null
            : List<dynamic>.from(
                tarificationIntervalles!.map((x) => x.toJson())),
      };
}
