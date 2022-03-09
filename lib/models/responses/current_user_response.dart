import 'package:json_annotation/json_annotation.dart';
import 'package:my_clean/models/user.dart';

part 'current_user_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CurrentUserResponse {
  String id;
  String phone;
  String password;
  String nom;
  String prenoms;
  String? email;

  CurrentUserResponse(
      {required this.id,
      required this.phone,
      required this.password,
      required this.nom,
      required this.prenoms,
      this.email});

  factory CurrentUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUserResponseToJson(this);
}
