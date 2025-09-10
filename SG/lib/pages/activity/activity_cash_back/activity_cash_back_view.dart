import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:get/get.dart';
import '../../../base/getx/base_view.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_urls_values.dart';
import '../../../routes/routes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/common_util.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_ovalends_progressbar.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/network_image/custom_network_image_placeholder.dart';
import '../a_model/activity_cash_back.dart';
import '../a_widget/promotion_desc_item_widget2.dart';
import '../all_promotions/all_promotions_view.dart';
import 'activity_cash_back_logic.dart';
import 'package:intl/intl.dart';

class ActivityCashBackPage extends BaseView<ActivityCashBackLogic> {
  ActivityCashBackPage({Key? key}) : super(key: key);

  // final logic = Get.find<ActivityCashBackLogic>();

  ///打开页面
  static openPage(String pid) {
    RouteUtil.pushToView(Routes.cashback, arguments: {"pid": pid});
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: S.current.random_text_896, showLeading: true);
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    controller.context = context;
    return controller.loading.value ? loadWidget() : Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppValues.largePadding,),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                  RouteUtil.popView();
                  if (!Get.previousRoute.contains('promotions')) {
                    AllPromotionsPage.openPage();
                  }
                },
                  child: const CustomIcon(asset: 'assets/images/normal/ic_normal_close.png',size: 16,)
                ),
              ],
            ),
            const SizedBox(height: AppValues.largePadding,),
            Obx(() => imageWidget(controller.imageUrl.value)),
            const SizedBox(height: 30,),
            Obx(() => CustomText(
              '${dateTimeToString(controller.model.value.startAt??0)} - ${dateTimeToString(controller.model.value.endAt??0)}',
              style: const TextStyle(fontSize: 12,color: AppThemes.textColorSecondary, fontWeight: FontWeight.w500),
            )),
            const SizedBox(height: 30,),
            progressWidget(),
            const SizedBox(height: AppValues.defaultMargin,),
            weekWidget(),
            const SizedBox(height: AppValues.defaultMargin,),
            listView(),
            const SizedBox(height: AppValues.defaultMargin,),
            rulesWidget(),
            const SizedBox(height: AppValues.halfMargin,),
            menusWidget(),
            const SizedBox(height: AppValues.defaultMargin,),
            Obx(() => controller.model.value.button == 1 ? bottomButton(controller.model.value.buttonText!) : Container()),
            const SizedBox(height: AppValues.halfMargin,),
            const SizedBox(height: AppValues.defaultMargin,),
            const SizedBox(height: 80,),
          ],
        ),
      ),
    );
  }

  Widget loadWidget() {
    return SizedBox(
      height: 150,
      child: CustomNetWorkImagePlaceholder(
        color: AppThemes.surfaceVariant.withOpacity(0),
        placeholderType: NetWorkImagePlaceholderType.loading,
      )
    );
  }

  Widget imageWidget(imageName) {
    return Container(
      height: 153,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
      ),
      child: CustomNetWorkImage(
        imageUrl: '${AppUrlsValues.envConfig.asset_url}/$imageName',
        fit: BoxFit.fill,
      )
    );
  }

  Widget progressWidget() {
    return Container(
      padding: const EdgeInsets.all(AppValues.padding_10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        color: AppThemes.surfaceVariant,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(() => CustomText(S.current.random_text_1061+'${int.parse(controller.levelData['level']??'0')}',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),)),
              const CustomAssetIcon(
                name: 'assets/images/activity/cashback.png',
                size: 48,
              ),
            ],
          ),
          const SizedBox(height: 10,),
          SizedBox(
            width: double.infinity,
            height: 6,
            child: Obx(() => CustomPaint(
              painter: OvalEndsProgressBar(progress: controller.percent.value,bgColor: const Color(0x26d9d9d9),valueColor: AppThemes.widgetColorWhite), // 传入进度值
            ))
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const Spacer(),
              Obx(() => CustomText(controller.needPay.value > 0 ? S.current.random_text_1062+'${controller.needPay.value.toStringAsFixed(2)}' : S.current.random_text_1062+' 0',style: const TextStyle(color: AppThemes.textColorSecondary,fontSize: 12,fontWeight: FontWeight.w600),))
            ],
          )
        ],
      ),
    );
  }

  Widget weekWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_10,vertical: AppValues.defaultMargin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        color: AppThemes.surfaceVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(S.current.random_text_1063,style: TextStyle(fontSize: 28,fontWeight: FontWeight.w600),),
          const SizedBox(height: 14,),
          CustomText('${S.current.random_text_1064}${controller.model.value.prizeConfig?.profitPrizeConfig?.last.bonusRate??0}${S.current.random_text_1065}',style: const TextStyle(color: AppThemes.textColorSecondary,fontSize: 16,fontWeight: FontWeight.w600),),
          const SizedBox(height: 14,),
          CustomText(S.current.random_text_902,style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
          Obx(() => CustomText(
            '${dateTimeToStringSecond(controller.model.value.countStartAt??0)} - ${dateTimeToStringSecond(controller.model.value.countEndAt??0)}',
            style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),
          )),
          const SizedBox(height: 14,),

          // getTimeWidget(),
          buttonWidget(enable: true),
        ],
      ),
    );
  }

  Widget getTimeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(S.current.random_text_903,style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
        CustomText(
          CommonUtil.getLocalTimeTitle(int.parse('1710922427')),
          style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget buttonWidget({bool enable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => controller.levelData?['receive'] == true
        ? CustomBigMainButton(
          title: S.current.random_text_904,
          fontWeight: FontWeight.w600,
          colorStyle:  CustomButtonColorStyle.tertiary,
          // isEnable: controller.levelData['receive'],
          onTap: (btnCtr) {
            controller.getBonus();
          },
        )
        : Opacity(
          opacity: 0.5,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
              color: AppThemes.primaryContainer,
            ),
            alignment: Alignment.center,
            child: CustomText(S.current.random_text_904,style: const TextStyle(color: AppThemes.black, fontWeight: FontWeight.w600),),
          ),
        )),
        const SizedBox(height: 14,),
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: S.current.random_text_905,
              style: TextStyle(color: enable ? AppThemes.textColorSecondary : AppThemes.scoreTextColor,fontWeight: FontWeight.w600),
            ),
            TextSpan(
                text: '${S.current.random_text_1066}${controller.days.value}${S.current.random_text_1067}',
                style: TextStyle(color: enable ? AppThemes.textColorSecondary : AppThemes.scoreTextColor,fontWeight: FontWeight.w600),),
          ])),
      ],
    );
  }

  Widget listView() {
    return Column(
      children: [
        listTitleView(),
        Obx(() => controller.model.value.prizeConfig?.profitPrizeConfig?.isNotEmpty ==true ? list(): Container())
      ],
    );
  }

  Widget listTitleView() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: CustomText(S.current.random_text_906, style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),)
          )
        ),
        Expanded(
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: CustomText(S.current.random_text_51, style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),)
          )
        ),
        Expanded(
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: CustomText(S.current.random_text_907, style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),)
          )
        ),
      ],
    );
  }

  Widget list() {
    return Obx(() => SizedBox(
      height: controller.model.value.prizeConfig!.profitPrizeConfig!.length > 10 ? 480 : (48 * controller.model.value.prizeConfig!.profitPrizeConfig!.length.toDouble()),
      child: ListView.builder(
        physics: controller.model.value.prizeConfig!.profitPrizeConfig!.length > 10 ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
        itemCount: controller.model.value.prizeConfig!.profitPrizeConfig!.length,
        itemBuilder: (BuildContext context, int index) {
          return listItemView(index,controller.model.value.prizeConfig!.profitPrizeConfig![index]);
        },
      ),
    ));
  }

  Widget listItemView(int index,ProfitPrizeConfig model) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
        color: index % 2 == 0 ? AppThemes.surfaceVariant : Colors.transparent,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: CustomText(model.level!, style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),)
            )
          ),
          Expanded(
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText((double.parse(model.validBetAmount!)).toStringAsFixed(2), style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),),
                  const SizedBox(width: 2,),
                  Obx(() => CustomNetWorkImage(imageUrl: "${controller.coinIcDomain}${controller.cur.value}${controller.coinIcExtensionName}",width: 18,height: 18,)),
                ],
              )
            )
          ),
          Expanded(
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: CustomText('${model.bonusRate!}%', style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w600),)
            )
          ),
        ],
      )
    );
  }

  Widget rulesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(S.current.random_text_908,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
        const SizedBox(height: 14,),
        Obx(() => Column(
          children: controller.rules.map((element) => rulesTextWidget(element)).toList(),
        ))
      ],
    );
  }

  Widget rulesTextWidget(String title) {
    return title.contains('\$\$currency\$\$') ? PromotionDescItemWidget2(
      title: title,
      needReplace: true,
      highestMoney:controller.model.value.prizeConfig!.prizeLimit??'',
      coinImageUrl: "${controller.coinIcDomain}${controller.cur.value}${controller.coinIcExtensionName}",
      titleStyle: ThemeService().textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),) 
    : Container(
      padding: const EdgeInsets.only(bottom: AppValues.padding_8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: ThemeService().textTheme.labelMedium?.color,
              borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: AppValues.padding_8),
          Expanded(
            child: CustomText(
              title,
              style: ThemeService()
                  .textTheme
                  .labelLarge
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  Widget menusWidget() {
    return Row(
      children: [
        menusItemWidget(S.current.random_text_826_copy),
        menusItemWidget(S.current.tab_bar_ent_copy),
      ],
    );
  }

  Widget menusItemWidget(title) {
    return Container(
      margin: const EdgeInsets.only(right: AppValues.defaultMargin),
      padding: const EdgeInsets.all(AppValues.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: ThemeService().colorScheme.surface
      ),
      alignment: Alignment.center,
      child: CustomText(title,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
    );
  }

  Widget bottomButton(String title) {
    return Container(
      width: double.infinity,
      height: 44,
      alignment: Alignment.center,
      child: CustomButton(
        width: 110,
        title: title,
        alignment: Alignment.center,
        textStyle: ThemeService().textTheme.labelMedium?.copyWith(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        decoration: ShapeDecoration(
          color: AppThemes.primaryContainer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppValues.smallRadius)),
        ),
        onTap: controller.onTap,
      ),
    );
  }
}

String dateTimeToString(int timestamp) {
  return DateFormat('yyyy/MM/dd').format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)).toString();
}

String dateTimeToStringSecond(int timestamp) {
  return DateFormat('yyyy/MM/dd hh:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)).toString();
}
