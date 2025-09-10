// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'k3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

K3 _$K3FromJson(Map<String, dynamic> json) => K3(
      subs: (json['subs'] as List<dynamic>?)
          ?.map((e) => Sub.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$K3ToJson(K3 instance) => <String, dynamic>{
      'subs': instance.subs,
    };
