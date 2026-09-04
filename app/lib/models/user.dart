import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

enum UserRole { parent, child, teacher }

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? preferredLanguage;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.preferredLanguage,
    required this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
