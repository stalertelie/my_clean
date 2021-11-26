// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentUserResponse _$CurrentUserResponseFromJson(Map<String, dynamic> json) {
  return CurrentUserResponse(
      id: json['@id'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String,
      nom: json['nom'] as String,
      prenoms: json['prenoms'],
      email: json['email'] as String);
}

Map<String, dynamic> _$CurrentUserResponseToJson(
        CurrentUserResponse instance) =>
    <String, dynamic>{
      '@id': instance.id,
      'phone': instance.phone,
      'password': instance.password,
      'nom': instance.nom,
      'prenoms': instance.prenoms,
      'email': instance.email,
    };
