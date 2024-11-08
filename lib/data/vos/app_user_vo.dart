import 'package:json_annotation/json_annotation.dart';
part 'app_user_vo.g.dart';

@JsonSerializable()
class AppUserVO {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String phone;
  final int age;
  final String gender;
  @JsonKey(name: 'is_banned')
  final bool isBanned;

  AppUserVO(
      {required this.uid,
      required this.email,
      required this.name,
      required this.bio,
      required this.phone,
      required this.age,
      required this.gender,
      required this.isBanned});

  factory AppUserVO.fromJson(Map<String, dynamic> json) =>
      _$AppUserVOFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserVOToJson(this);
}
