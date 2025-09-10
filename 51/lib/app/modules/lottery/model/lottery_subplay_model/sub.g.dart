// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sub _$SubFromJson(Map<String, dynamic> json) => Sub(
      groupName: json['groupName'] as String?,
      playids: (json['playids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$SubToJson(Sub instance) => <String, dynamic>{
      'groupName': instance.groupName,
      'playids': instance.playids,
    };
