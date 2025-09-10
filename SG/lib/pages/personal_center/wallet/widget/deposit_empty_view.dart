import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/personal_center/wallet/auth_widget.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/vault_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_tips*_text.dart.dart';
import 'package:get/get.dart';

import '../../../../widget/custom_text.dart';

class DepositEmptyView extends GetView {
  final tips;

  DepositEmptyView({super.key, this.tips});



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _tips(),
        Obx(() {
          return Visibility(visible: VaultUtil.isSecretNot()&&!VaultUtil.isEmailCheckStateNotBind(), child: const AuthWidget());
        })
      ],
    );
  }

  Widget _tips(){
    return Container(
      margin: const EdgeInsets.only(top: AppValues.defaultMargin,left:  AppValues.defaultMargin,right:  AppValues.defaultMargin),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/personal_center_icon/wallet/cards_tips_bg.png'),
              fit: BoxFit.fill
          )
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 25,bottom: 25),
          child: LangUtil().isPtBr() || LangUtil().isViVn()?ptbrAndVivnLanguage(): Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/personal_center_icon/wallet/cards_warning.png',width: 16,),
              SizedBox(width: 6,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText("$tips",textColorStyle: CustomTextColorStyle.secondary,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                  CustomText(S.current.random_text_714,textColorStyle: CustomTextColorStyle.secondary,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ptbrAndVivnLanguage(){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 40,),
        Image.asset('assets/images/personal_center_icon/wallet/cards_warning.png',width: 16,),
        const SizedBox(width: 6,),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: AppValues.margin_20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText("$tips",textColorStyle: CustomTextColorStyle.secondary,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
                CustomText(S.current.random_text_714,textColorStyle: CustomTextColorStyle.secondary,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12),),
              ],
            ),
          ),
        ),
      ],
    );
  }

}