class Categorieservice {
  Categorieservice({
    this.id,
    this.type,
    this.title,
  });

  String? id;
  String? type;
  String? title;

  factory Categorieservice.fromJson(Map<String, dynamic> json) => Categorieservice(
    id: json["@id"] == null ? null : json["@id"],
    type: json["@type"] == null ? null : json["@type"],
    title: json["title"] == null ? null : json["title"],
  );

  Map<String, dynamic> toJson() => {
    "@id": id == null ? null : id,
    "@type": type == null ? null : type,
    "title": title == null ? null : title,
  };
}
