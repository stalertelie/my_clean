class Tarification {
  Tarification({
    this.id,
    this.type,
    this.tarificationId,
    this.unite,
    this.prix,
    this.optionValue,
    this.service,
  });

  String? id;
  String? type;
  int? tarificationId;
  String? unite;
  int? prix;
  String? optionValue;
  String? service;

  factory Tarification.fromJson(Map<String, dynamic> json) => Tarification(
    id: json["@id"],
    type: json["@type"],
    tarificationId: json["id"],
    unite: json["unite"],
    prix: json["prix"],
    optionValue: json["optionValue"],
    service: json["service"],
  );

  Map<String, dynamic> toJson() => {
    "@id": id,
    "@type": type,
    "id": tarificationId,
    "unite": unite,
    "prix": prix,
    "optionValue": optionValue,
    "service": service,
  };
}
