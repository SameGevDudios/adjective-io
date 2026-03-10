import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prefix.g.dart';

@JsonSerializable()
class Prefix extends Equatable {
  final String title;
  final String subtitle;

  @override
  List<Object?> get props => [title, subtitle];

  const Prefix({required this.title, required this.subtitle});

  factory Prefix.empty() => const Prefix(title: 'Ты', subtitle: 'самая...');

  factory Prefix.fromJson(Map<String, dynamic> json) => _$PrefixFromJson(json);

  Map<String, dynamic> toJson() => _$PrefixToJson(this);
}
