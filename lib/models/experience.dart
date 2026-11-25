import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Experience {
  const Experience({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    this.thumbnail,
    required this.startedAt,
    this.endedAt,
    this.isOngoing = false,
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String description;
  final String category;

  final String? thumbnail;

  final DateTime startedAt;
  final DateTime? endedAt;

  @JsonKey(includeToJson: false)
  final bool isOngoing;

  @JsonKey(includeToJson: false)
  final int starCount;

  @JsonKey(includeToJson: false)
  final bool isStarred;

  @JsonKey(includeToJson: false)
  final String starredByNames;

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);
}
