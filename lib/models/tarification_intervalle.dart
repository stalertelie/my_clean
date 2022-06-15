class TarificationIntervalle {
  TarificationIntervalle({
    this.id,
    this.type,
    this.tarificationIntervalleId,
    this.min,
    this.max,
    this.initialNumber,
    this.price,
    this.tarificationIntervalleOperator,
    this.operatorValue,
  });

  String? id;
  String? type;
  int? tarificationIntervalleId;
  int? min;
  int? max;
  int? initialNumber;
  int? price;
  String? tarificationIntervalleOperator;
  int? operatorValue;

  factory TarificationIntervalle.fromJson(Map<String, dynamic> json) =>
      TarificationIntervalle(
        id: json["@id"],
        type: json["@type"],
        tarificationIntervalleId: json["id"],
        min: json["min"],
        max: json["max"],
        initialNumber: json["initialNumber"],
        price: json["price"],
        tarificationIntervalleOperator: json["operator"],
        operatorValue: json["operatorValue"],
      );

  Map<String, dynamic> toJson() => {
        "@id": id,
        "@type": type,
        "id": tarificationIntervalleId,
        "min": min,
        "max": max,
        "initialNumber": initialNumber,
        "price": price,
        "operator": tarificationIntervalleOperator,
        "operatorValue": operatorValue,
      };
}
