class ExtraService {
  ExtraService({
    this.id,
    this.type,
    this.extraServiceId,
    this.title,
    this.image,
  });

  String? id;
  String? type;
  int? extraServiceId;
  String? title;
  String? image;

  factory ExtraService.fromJson(Map<String, dynamic> json) => ExtraService(
    id: json["@id"],
    type: json["@type"],
    extraServiceId: json["id"],
    title: json["title"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "@id": id,
    "@type": type,
    "id": extraServiceId,
    "title": title,
    "image": image,
  };
}
