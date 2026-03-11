// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preference _$PreferenceFromJson(Map<String, dynamic> json) => Preference(
  id: json['id'] as String,
  adjective: json['adjective'] as String,
  weight: (json['weight'] as num).toDouble(),
);

Map<String, dynamic> _$PreferenceToJson(Preference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adjective': instance.adjective,
      'weight': instance.weight,
    };
