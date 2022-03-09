
import 'package:json_annotation/json_annotation.dart';

part 'frequence.g.dart';

@JsonSerializable()
class Frequence {
  String? day;
  String? time;

  Frequence({ this.day, this.time });
  factory Frequence.fromJson(Map<String, dynamic> json) =>
      _$FrequenceFromJson(json);
       Map<String, dynamic> toJson() => _$FrequenceToJson(this);
}