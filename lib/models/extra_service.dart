class ExtraService {
  ExtraService(
      {this.id,
      this.type,
      this.extraServiceId,
      this.title,
      this.image,
      this.price,
      this.contentUrl});

  String? id;
  String? type;
  int? extraServiceId;
  String? title;
  String? image;
  String? contentUrl;
  int? price;

  factory ExtraService.fromJson(Map<String, dynamic> json) => ExtraService(
        id: json["@id"],
        type: json["@type"],
        extraServiceId: json["id"],
        title: json["title"],
        image: json["image"],
        price: json["price"],
        contentUrl: json["contentUrl"],
      );

  Map<String, dynamic> toJson() => {
        "@id": id,
        "@type": type,
        "id": extraServiceId,
        "title": title,
        "image": image,
        "price": price,
      };
}
