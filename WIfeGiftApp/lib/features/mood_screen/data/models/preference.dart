import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preference.g.dart';

@JsonSerializable()
class Preference extends Equatable {
  final String id;
  final String adjective;
  final double weight;

  @override
  List<Object> get props => [id, adjective, weight];

  const Preference({required this.id, required this.adjective, required this.weight});

  factory Preference.fromJson(Map<String, dynamic> json) => _$PreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$PreferenceToJson(this);
}
