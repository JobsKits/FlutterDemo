import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import '../../../base/getx/base_view.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_urls_values.dart';
import '../../../routes/routes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/network_image/custom_network_image_placeholder.dart';
import '../all_promotions/all_promotions_view.dart';
import 'activity_custom_logic.dart';

class ActivityCustomPage extends BaseView<ActivityCustomLogic> {
  ActivityCustomPage({Key? key}) : super(key: key);

  // final logic = Get.find<ActivityCashBackLogic>();

  ///打开页面
  static openPage(String? pid) {
    RouteUtil.pushToView(Routes.customActivity, arguments: {"pid": pid});
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(appBarTitleText: S.current.random_text_896, showLeading: true);
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return controller.loading.value ? loadWidget() : Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.defaultPadding),
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
            Obx(() => imageWidget(controller.model.value.image)),
            const SizedBox(
              height: AppValues.defaultMargin,
            ),
            Obx(() => SingleChildScrollView(child: Html(data: controller.model.value.detail))),
            Obx(() => controller.model.value.button == 1 ? Column(
              children: [
                const SizedBox(
                  height: AppValues.defaultMargin,
                ),
                Obx(() =>  bottomButton(controller.buttonText.value)),
              ],
            ) : Container()),
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
        ));
  }

  Widget rulesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rulesTextWidget(S.current.random_text_909, S.current.random_text_965),
        rulesTextWidget(S.current.random_text_910, S.current.random_text_965),
      ],
    );
  }

  Widget rulesTextWidget(title, context) {
    return Container(
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
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                style: ThemeService()
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 6,
              ),
              CustomText(
                title,
                style: ThemeService().textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ))
        ],
      ),
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
