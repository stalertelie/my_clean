class Frequence {
  Frequence({
    this.id,
    this.type,
    this.frequenceId,
    this.label,
  });

  String? id;
  String? type;
  int? frequenceId;
  String? label;

  factory Frequence.fromJson(Map<String, dynamic> json) => Frequence(
    id: json["@id"] == null ? null : json["@id"],
    type: json["@type"] == null ? null : json["@type"],
    frequenceId: json["id"] == null ? null : json["id"],
    label: json["label"] == null ? null : json["label"],
  );

  Map<String, dynamic> toJson() => {
    "@id": id == null ? null : id,
    "@type": type == null ? null : type,
    "id": frequenceId == null ? null : frequenceId,
    "label": label == null ? null : label,
  };
}