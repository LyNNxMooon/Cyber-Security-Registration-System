// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUserVO _$AppUserVOFromJson(Map<String, dynamic> json) => AppUserVO(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String,
      phone: json['phone'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      isBanned: json['is_banned'] as bool,
    );

Map<String, dynamic> _$AppUserVOToJson(AppUserVO instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'bio': instance.bio,
      'phone': instance.phone,
      'age': instance.age,
      'gender': instance.gender,
      'is_banned': instance.isBanned,
    };
