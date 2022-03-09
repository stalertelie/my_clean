class Categorieservice {
  Categorieservice({
    this.id,
    this.type,
    this.title,
    this.image,
  });

  String? id;
  String? type;
  String? title;
  String? image;

  factory Categorieservice.fromJson(Map<String, dynamic> json) => Categorieservice(
    id: json["@id"] == null ? null : json["@id"],
    type: json["@type"] == null ? null : json["@type"],
    title: json["title"] == null ? null : json["title"],
    image: json["image"] == null ? null : json["image"],
  );

  Map<String, dynamic> toJson() => {
    "@id": id == null ? null : id,
    "@type": type == null ? null : type,
    "title": title == null ? null : title,
    "image": image == null ? null : image,
  };
}
