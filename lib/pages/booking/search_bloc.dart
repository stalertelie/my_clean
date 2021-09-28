import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_clean/models/base_bloc.dart';
import 'package:my_clean/models/loading.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc extends BaseBloc{
  Stream<List<Feature>> get featuresStream => _featuresSubject.stream;
  final _featuresSubject = BehaviorSubject<List<Feature>>();

  BehaviorSubject<List<Feature>> get featuresSubject => _featuresSubject;

  getProposition(String q) async {
    loadingSubject.add(Loading(loading: true));
    final response = await http.get(
      Uri.parse(
          "https://api.openrouteservice.org/geocode/search?api_key=5b3ce3597851110001cf6248371779f82bd7423b8a465db17732a74a&text=$q&boundary.country=CIV"),
      headers: {"Content-Type": "application/json; charset=utf-8"},
    );
    try {
      loadingSubject.add(Loading(loading: false));
      if (response.statusCode == 200) {
        List<Feature> features =
        (jsonDecode(response.body.toString())['features'] as List)
            .map<Feature>((i) {
          return Feature.fromJson(i);
        }).toList();
        _featuresSubject.add(features);
      }
    } catch(ex){
      loadingSubject.add(Loading(loading: false));
    }

  }
}

class Feature {
  Feature({
    this.type,
    this.geometry,
    this.properties,
    this.bbox,
  });

  String? type;
  Geometry? geometry;
  Properties? properties;
  List<double>? bbox;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: json["type"] == null ? null : json["type"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        properties: json["properties"] == null
            ? null
            : Properties.fromJson(json["properties"]),
        bbox: json["bbox"] == null
            ? null
            : List<double>.from(json["bbox"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "geometry": geometry == null ? null : geometry!.toJson(),
        "properties": properties == null ? null : properties!.toJson(),
        "bbox": bbox == null ? null : List<dynamic>.from(bbox!.map((x) => x)),
      };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String? type;
  List<double>? coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"] == null ? null : json["type"],
        coordinates: json["coordinates"] == null
            ? null
            : List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "coordinates": coordinates == null
            ? null
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class Properties {
  Properties({
    this.id,
    this.gid,
    this.layer,
    this.source,
    this.sourceId,
    this.name,
    this.confidence,
    this.matchType,
    this.accuracy,
    this.country,
    this.countryGid,
    this.countryA,
    this.region,
    this.regionGid,
    this.regionA,
    this.locality,
    this.localityGid,
    this.continent,
    this.continentGid,
    this.label,
    this.county,
    this.countyGid,
    this.countyA,
  });

  String? id;
  String? gid;
  String? layer;
  String? source;
  String? sourceId;
  String? name;
  int? confidence;
  String? matchType;
  String? accuracy;
  String? country;
  String? countryGid;
  String? countryA;
  String? region;
  String? regionGid;
  String? regionA;
  String? locality;
  String? localityGid;
  String? continent;
  String? continentGid;
  String? label;
  String? county;
  String? countyGid;
  String? countyA;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        id: json["id"] == null ? null : json["id"],
        gid: json["gid"] == null ? null : json["gid"],
        layer: json["layer"] == null ? null : json["layer"],
        source: json["source"] == null ? null : json["source"],
        sourceId: json["source_id"] == null ? null : json["source_id"],
        name: json["name"] == null ? null : json["name"],
        confidence: json["confidence"] == null ? null : json["confidence"],
        matchType: json["match_type"] == null ? null : json["match_type"],
        accuracy: json["accuracy"] == null ? null : json["accuracy"],
        country: json["country"] == null ? null : json["country"],
        countryGid: json["country_gid"] == null ? null : json["country_gid"],
        countryA: json["country_a"] == null ? null : json["country_a"],
        region: json["region"] == null ? null : json["region"],
        regionGid: json["region_gid"] == null ? null : json["region_gid"],
        regionA: json["region_a"] == null ? null : json["region_a"],
        locality: json["locality"] == null ? null : json["locality"],
        localityGid: json["locality_gid"] == null ? null : json["locality_gid"],
        continent: json["continent"] == null ? null : json["continent"],
        continentGid:
            json["continent_gid"] == null ? null : json["continent_gid"],
        label: json["label"] == null ? null : json["label"],
        county: json["county"] == null ? null : json["county"],
        countyGid: json["county_gid"] == null ? null : json["county_gid"],
        countyA: json["county_a"] == null ? null : json["county_a"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "gid": gid == null ? null : gid,
        "layer": layer == null ? null : layer,
        "source": source == null ? null : source,
        "source_id": sourceId == null ? null : sourceId,
        "name": name == null ? null : name,
        "confidence": confidence == null ? null : confidence,
        "match_type": matchType == null ? null : matchType,
        "accuracy": accuracy == null ? null : accuracy,
        "country": country == null ? null : country,
        "country_gid": countryGid == null ? null : countryGid,
        "country_a": countryA == null ? null : countryA,
        "region": region == null ? null : region,
        "region_gid": regionGid == null ? null : regionGid,
        "region_a": regionA == null ? null : regionA,
        "locality": locality == null ? null : locality,
        "locality_gid": localityGid == null ? null : localityGid,
        "continent": continent == null ? null : continent,
        "continent_gid": continentGid == null ? null : continentGid,
        "label": label == null ? null : label,
        "county": county == null ? null : county,
        "county_gid": countyGid == null ? null : countyGid,
        "county_a": countyA == null ? null : countyA,
      };
}
