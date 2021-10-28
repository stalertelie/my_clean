import 'package:my_clean/models/GoogleSearch/google_result.dart';

class GoogleSearchResult {
  GoogleSearchResult({
    this.results,
    this.status,
  });

  List<GoogleResult>? results;
  String? status;

  factory GoogleSearchResult.fromJson(Map<String, dynamic> json) => GoogleSearchResult(
    results: json["results"] == null ? null : List<GoogleResult>.from(json["results"].map((x) => GoogleResult.fromJson(x))),
    status: json["status"] == null ? null : json["status"],
  );

}