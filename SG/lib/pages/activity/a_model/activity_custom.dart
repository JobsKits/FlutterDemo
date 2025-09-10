// To parse this JSON data, do
//
//     final customActivityModel = customActivityModelFromJson(jsonString);

import 'dart:convert';

CustomActivityModel customActivityModelFromJson(String str) => CustomActivityModel.fromJson(json.decode(str));

String customActivityModelToJson(CustomActivityModel data) => json.encode(data.toJson());

class CustomActivityModel {
    String? detail;
    int? buttonType;
    int? button;
    String? buttonText;
    String? buttonRedirect;
    int? displayStartAt;
    int? displayEndAt;
    String? displayType;
    String? pageContent;
    String? bannerStyle;
    String? bannerUrl;
    String? bannerBackground;
    String? bannerIcon;
    String? bannerContent;
    String? image;

    CustomActivityModel({
        this.detail,
        this.buttonType,
        this.button,
        this.buttonText,
        this.buttonRedirect,
        this.displayStartAt,
        this.displayEndAt,
        this.displayType,
        this.pageContent,
        this.bannerStyle,
        this.bannerUrl,
        this.bannerBackground,
        this.bannerIcon,
        this.bannerContent,
        this.image,
    });

    factory CustomActivityModel.fromJson(Map<String, dynamic> json) => CustomActivityModel(
        detail: json["detail"],
        buttonType: json["button_type"],
        button: json["button"],
        buttonText: json["button_text"],
        buttonRedirect: json["button_redirect"],
        displayStartAt: json["display_start_at"],
        displayEndAt: json["display_end_at"],
        displayType: json["display_type"],
        pageContent: json["page_content"],
        bannerStyle: json["banner_style"],
        bannerUrl: json["banner_url"],
        bannerBackground: json["banner_background"],
        bannerIcon: json["banner_icon"],
        bannerContent: json["banner_content"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "detail": detail,
        "button_type": buttonType,
        "button": button,
        "button_text": buttonText,
        "button_redirect": buttonRedirect,
        "display_start_at": displayStartAt,
        "display_end_at": displayEndAt,
        "display_type": displayType,
        "page_content": pageContent,
        "banner_style": bannerStyle,
        "banner_url": bannerUrl,
        "banner_background": bannerBackground,
        "banner_icon": bannerIcon,
        "banner_content": bannerContent,
        "image": image,
    };
}
