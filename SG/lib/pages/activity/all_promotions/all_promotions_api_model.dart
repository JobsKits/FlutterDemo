// 活动列表 api model
import '../a_model/activity_common_params.dart';

class AllPromotionsApiModel {
  String? id;
  String? name;
  int? ty;
  String? category;
  int? group;
  String? groupDetail;
  int? display;
  int? displayStartAt;
  int? displayEndAt;
  int? state;
  int? startAt;
  int? endAt;
  int? shortcut;
  String? currencyId;
  dynamic currencys;
  int? automatic;
  int? withdrawType;
  String? images;
  String? summary;
  String? detail;
  int? button;
  String? buttonText;
  int? detailImage;
  String? config;
  int? createdAt;
  String? createdUid;
  String? createdName;
  int? updatedAt;
  String? updatedUid;
  String? updatedName;

  //新增配置字段
  String? displayType; //展示方式 1:内置页面 2:跳转外部链接
  int? buttonType; //跳转类型 1自定义 2娱乐城 3体育 4保险库 5VIP 6联盟计画 7优惠活动 8在线客服
  String? buttonRedirect;
  String? endAtTz;

  ///获取按钮状态
  ActivityTimeState getBtnState() {
    return ActivityTimeState.adaptor(state);
  }

  AllPromotionsApiModel({
    this.id,
    this.name,
    this.ty,
    this.category,
    this.group,
    this.groupDetail,
    this.display,
    this.displayStartAt,
    this.displayEndAt,
    this.state,
    this.startAt,
    this.endAt,
    this.shortcut,
    this.currencyId,
    this.currencys,
    this.automatic,
    this.withdrawType,
    this.images,
    this.summary,
    this.detail,
    this.button,
    this.buttonText,
    this.detailImage,
    this.config,
    this.createdAt,
    this.createdUid,
    this.createdName,
    this.updatedAt,
    this.updatedUid,
    this.updatedName,
    this.displayType,
    this.buttonType,
    this.buttonRedirect,
    this.endAtTz,
  });

  factory AllPromotionsApiModel.fromJson(Map<String, dynamic> json) => AllPromotionsApiModel(
        id: json["id"],
        name: json["name"],
        ty: json["ty"],
        category: json["category"],
        group: json["group"],
        groupDetail: json["group_detail"],
        display: json["display"],
        displayStartAt: json["display_start_at"],
        displayEndAt: json["display_end_at"],
        state: json["state"],
        startAt: json["start_at"],
        endAt: json["end_at"],
        shortcut: json["shortcut"],
        currencyId: json["currency_id"],
        currencys: json["currencys"],
        automatic: json["automatic"],
        withdrawType: json["withdraw_type"],
        images: json["images"],
        summary: json["summary"],
        detail: json["detail"],
        button: json["button"],
        buttonText: json["button_text"],
        detailImage: json["detail_image"],
        config: json["config"],
        createdAt: json["created_at"],
        createdUid: json["created_uid"],
        createdName: json["created_name"],
        updatedAt: json["updated_at"],
        updatedUid: json["updated_uid"],
        updatedName: json["updated_name"],
        displayType: json["display_type"],
        buttonType: json["button_type"],
        buttonRedirect: json["button_redirect"],
        endAtTz: json["end_at_tz"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ty": ty,
        "category": category,
        "group": group,
        "group_detail": groupDetail,
        "display": display,
        "display_start_at": displayStartAt,
        "display_end_at": displayEndAt,
        "state": state,
        "start_at": startAt,
        "end_at": endAt,
        "shortcut": shortcut,
        "currency_id": currencyId,
        "currencys": currencys,
        "automatic": automatic,
        "withdraw_type": withdrawType,
        "images": images,
        "summary": summary,
        "detail": detail,
        "button": button,
        "button_text": buttonText,
        "detail_image": detailImage,
        "config": config,
        "created_at": createdAt,
        "created_uid": createdUid,
        "created_name": createdName,
        "updated_at": updatedAt,
        "updated_uid": updatedUid,
        "updated_name": updatedName,
        "display_type": displayType,
        "button_type": buttonType,
        "button_redirect": buttonRedirect,
        "end_at_tz": endAtTz,
      };
}
