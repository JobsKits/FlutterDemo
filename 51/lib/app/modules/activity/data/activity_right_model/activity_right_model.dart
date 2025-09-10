import 'package:json_annotation/json_annotation.dart';

import 'activity_pg_list.dart';

part 'activity_right_model.g.dart';

@JsonSerializable()
class ActivityRightModel {
  int? tid;
  int? id;
  String? categoryName;
  String? categoryType;
  String? categoryPic;
  String? categoryPic2;
  int? isShowCategoryPic;
  String? status;
  int? orderNum;
  String? createBy;
  String? updateBy;
  int? updateTime;
  List<ActivityPgList>? activityPgList;

  ActivityRightModel({
    this.tid,
    this.id,
    this.categoryName,
    this.categoryType,
    this.categoryPic,
    this.categoryPic2,
    this.isShowCategoryPic,
    this.status,
    this.orderNum,
    this.createBy,
    this.updateBy,
    this.updateTime,
    this.activityPgList,
  });

  @override
  String toString() {
    return 'ActivityRightModel(tid: $tid, id: $id, categoryName: $categoryName, categoryType: $categoryType, categoryPic: $categoryPic, categoryPic2: $categoryPic2, isShowCategoryPic: $isShowCategoryPic, status: $status, orderNum: $orderNum, createBy: $createBy, updateBy: $updateBy, updateTime: $updateTime, activityPgList: $activityPgList)';
  }

  factory ActivityRightModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityRightModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityRightModelToJson(this);

  ActivityRightModel copyWith({
    int? tid,
    int? id,
    String? categoryName,
    String? categoryType,
    String? categoryPic,
    String? categoryPic2,
    int? isShowCategoryPic,
    String? status,
    int? orderNum,
    String? createBy,
    String? updateBy,
    int? updateTime,
    List<ActivityPgList>? activityPgList,
  }) {
    return ActivityRightModel(
      tid: tid ?? this.tid,
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      categoryType: categoryType ?? this.categoryType,
      categoryPic: categoryPic ?? this.categoryPic,
      categoryPic2: categoryPic2 ?? this.categoryPic2,
      isShowCategoryPic: isShowCategoryPic ?? this.isShowCategoryPic,
      status: status ?? this.status,
      orderNum: orderNum ?? this.orderNum,
      createBy: createBy ?? this.createBy,
      updateBy: updateBy ?? this.updateBy,
      updateTime: updateTime ?? this.updateTime,
      activityPgList: activityPgList ?? this.activityPgList,
    );
  }
}
