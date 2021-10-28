import 'package:my_clean/models/GoogleSearch/location.dart';

class Geometry {
  Geometry({
    this.location,
  });

  Location? location;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: json["location"] == null ? null : Location.fromJson(json["location"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location == null ? null : location?.toJson(),
  };
}