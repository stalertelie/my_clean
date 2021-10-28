import 'package:my_clean/models/GoogleSearch/geometry.dart';

class GoogleResult {
  GoogleResult({
    this.businessStatus,
    this.formattedAddress,
    this.geometry,
    this.name,
    this.types,
    this.userRatingsTotal,
  });

  String? businessStatus;
  String? formattedAddress;
  Geometry? geometry;
  String? name;
  List<String>? types;
  int? userRatingsTotal;

  factory GoogleResult.fromJson(Map<String, dynamic> json) => GoogleResult(
    businessStatus: json["business_status"] == null ? null : json["business_status"],
    formattedAddress: json["formatted_address"] == null ? null : json["formatted_address"],
    geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
    name: json["name"] == null ? null : json["name"],
    types: json["types"] == null ? null : List<String>.from(json["types"].map((x) => x)),
    userRatingsTotal: json["user_ratings_total"] == null ? null : json["user_ratings_total"],
  );

  Map<String, dynamic> toJson() => {
    "business_status": businessStatus == null ? null : businessStatus,
    "formatted_address": formattedAddress == null ? null : formattedAddress,
    "geometry": geometry == null ? null : geometry?.toJson(),
    "name": name == null ? null : name,
    "types": types == null ? null : List<dynamic>.from(types!.map((x) => x)),
    "user_ratings_total": userRatingsTotal == null ? null : userRatingsTotal,
  };
}