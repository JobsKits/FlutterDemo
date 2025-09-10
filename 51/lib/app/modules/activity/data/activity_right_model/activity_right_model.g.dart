// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_right_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityRightModel _$ActivityRightModelFromJson(Map<String, dynamic> json) =>
    ActivityRightModel(
      tid: (json['tid'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      categoryName: json['categoryName'] as String?,
      categoryType: json['categoryType'] as String?,
      categoryPic: json['categoryPic'] as String?,
      categoryPic2: json['categoryPic2'] as String?,
      isShowCategoryPic: (json['isShowCategoryPic'] as num?)?.toInt(),
      status: json['status'] as String?,
      orderNum: (json['orderNum'] as num?)?.toInt(),
      createBy: json['createBy'] as String?,
      updateBy: json['updateBy'] as String?,
      updateTime: (json['updateTime'] as num?)?.toInt(),
      activityPgList: (json['activityPgList'] as List<dynamic>?)
          ?.map((e) => ActivityPgList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivityRightModelToJson(ActivityRightModel instance) =>
    <String, dynamic>{
      'tid': instance.tid,
      'id': instance.id,
      'categoryName': instance.categoryName,
      'categoryType': instance.categoryType,
      'categoryPic': instance.categoryPic,
      'categoryPic2': instance.categoryPic2,
      'isShowCategoryPic': instance.isShowCategoryPic,
      'status': instance.status,
      'orderNum': instance.orderNum,
      'createBy': instance.createBy,
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime,
      'activityPgList': instance.activityPgList,
    };
