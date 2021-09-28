import 'package:my_clean/models/categorie_service.dart';
import 'package:my_clean/models/extra_service.dart';
import 'package:my_clean/models/tarification.dart';

class Services {
  Services({
    this.id,
    this.type,
    this.title,
    this.image,
    this.extraServices,
    this.contentUrl,
    this.updateAt,
    this.tarifications,
    this.categorieService,
    this.services,
    this.isPrincipal,
  });

  String? id;
  String? type;
  String? title;
  String? image;
  List<ExtraService>? extraServices;
  String? contentUrl;
  DateTime? updateAt;
  List<Tarification>? tarifications;
  Categorieservice? categorieService;
  List<Services>? services;
  bool? isPrincipal;

  factory Services.fromJson(Map<String, dynamic> json) => Services(
    id: json["@id"],
    type: json["@type"],
    title: json["title"],
    image: json["image"],
    extraServices: json["extraServices"] == null ? null : List<ExtraService>.from(json["extraServices"].map((x) => ExtraService.fromJson(x))),
    contentUrl: json["contentUrl"],
    updateAt: json["updateAt"] == null ? null : DateTime.parse(json["updateAt"]),
    tarifications: json["tarifications"] == null ? null : List<Tarification>.from(json["tarifications"].map((x) => Tarification.fromJson(x))),
    categorieService: json["categorieService"] == null ? null : Categorieservice.fromJson(json["categorieService"]),
    services: json["services"] == null ? null : List<Services>.from(json["services"].map((x) => Services.fromJson(x))),
    isPrincipal: json["isPrincipal"],
  );

  Map<String, dynamic> toJson() => {
    "@id": id,
    "@type": type,
    "title": title,
    "image": image,
    "extraServices": extraServices == null ? null : List<dynamic>.from(extraServices!.map((x) => x.toJson())),
    "contentUrl": contentUrl,
    // ignore: prefer_null_aware_operators
    "updateAt": updateAt == null ? null : updateAt?.toIso8601String(),
    "tarifications": tarifications == null ? null : List<dynamic>.from(tarifications!.map((x) => x.toJson())),
    "categorieService": categorieService,
    "services": services == null ? null : List<dynamic>.from(services!.map((x) => x.toJson())),
    "isPrincipal": isPrincipal,
  };
}