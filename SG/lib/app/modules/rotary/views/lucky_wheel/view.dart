import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constant/app_themes.dart';
import '../../../../../constant/app_values.dart';
import '../../../../../services/theme/theme_service.dart';
import '../../../../../widget/custom_asset_icon.dart';
import '../../../../../widget/custom_icon.dart';
import '../../../../../widget/custom_text.dart';
import '../../../../../widget/dialog/custom_safe_dialog.dart';
import '../../../../../widget/network_image/custom_network_image.dart';
import '../lucky_wheel_view.dart';
import 'index.dart';

Future<void> showLuckyWheelWidget<T>({
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  String id = '256610365262037311',
  String currencyId = '',
  int rollTimes = 1,
  void Function()? onDialogDelete,
}) async {
  await CustomSafeDialog.show<T>(
      context: Get.context!,
      tag: 'kLuckyWheelWidget',
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (_) {
        GlobalStateController.of().showOverlayView(isShowTopBarView: false, isShowBottomBarView: false);
        return LuckyWheelPage(
          id: id,
          currencyId: currencyId,
          rollTimes: rollTimes,
        );
      }).then((value) {
        if (onDialogDelete != null) {
          onDialogDelete.call();
        }
      });
}

class LuckyWheelPage extends GetView<LuckyWheelController> {
  const LuckyWheelPage({
    Key? key,
    this.id = '256610365262037311',
    this.currencyId = '',
    this.rollTimes = 1
  }) : super(key: key);
  final String? id;
  final String? currencyId;
  final int? rollTimes;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LuckyWheelController>(
      init: LuckyWheelController(),
      id: "lucky_wheel",
      builder: (_) {
        return Scaffold(
          // appBar: AppBar(title: const Text("lucky_wheel")),
          backgroundColor: Colors.transparent,
          body: _buildView(),
        );
      },
    );
  }
  // 主视图
  Widget _buildView() {
    return Stack(
      children: [
        GestureDetector(
          onTap: controller.onTap,
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Center(
          child: SizedBox(
            width: 332,
            height: 386,
            child: stackView(),
          ),
          // child: Container(
          //   margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
          //   width: Get.width,
          //   height: 400,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(AppValues.smallRadius),
          //     color: ThemeService().theme.scaffoldBackgroundColor,
          //   ),
          //   child: Column(
          //     children: [
          //       _buildTop(),
          //       _buildBody(),
          //     ],
          //   ),
          // ),
        ),
      ],
    );
  }

  Widget stackView() {
    return Stack(
      children: [
        Positioned(
          right: 8,
          child: InkWell(
            onTap: controller.onTap,
            child: const CustomIcon(
              asset: 'assets/images/wheel/close.png',
              size: 18,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18, left: 16),
          child: Image.asset(
            'assets/images/wheel/loong.png',
            width: 170,
          ),
        ),
        Positioned(
          right: 8,
          child: Padding(
            padding: const EdgeInsets.only(top: 18),
            child: Image.asset(
              'assets/images/wheel/tiger.png',
              width: 175,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 96),
          child: LuckyWheelWidget(
            showLight: false,
            id: id,
            currencyId: currencyId,
            times: rollTimes,
            onTap: (bonus) => controller.onTap(),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35, right: 30),
              child: Image.asset(
                'assets/images/wheel/777.png',
                width: 151,
              ),
            )),
        Positioned(
          bottom: 32,
          child: Image.asset(
            'assets/images/wheel/girl.png',
            width: 109,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 30,
          child: Image.asset(
            'assets/images/wheel/boy.png',
            width: 146,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Image.asset(
            'assets/images/wheel/lang_${controller.globalController.langType.value}.png',
            width: 332,
          ),
        ),
      ],
    );
  }

  Widget _buildTop() {
    return Padding(
      padding: const EdgeInsets.all(AppValues.padding_16),
      child: Column(
        children: [
          Row(
            children: [
              const CustomIcon(
                asset: 'assets/images/wheel/wheel_s.png',
                size: 18,
              ),
              const SizedBox(
                width: AppValues.padding_8,
              ),
              CustomText(
                S.current.random_text_839,
                style: ThemeService()
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              InkWell(
                onTap: controller.onTap,
                child: const CustomIcon(
                  asset: 'assets/images/normal/ic_normal_close.png',
                  size: 18,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomNetWorkImage(
              imageUrl: "${controller.coinIcDomain}706${controller.coinIcExtensionName}",
              width: 18,
              height: 18,
            ),
            const SizedBox(
              width: 5,
            ),
            CustomText(
              S.current.random_text_1008,
              style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(
          height: AppValues.padding_16,
        ),
        LuckyWheelWidget(
          showLight: false,
          isFull:true,
          id: id,
          currencyId: currencyId,
          onTap: (bonus) => controller.onTap(),
        ),
        const SizedBox(
          height: AppValues.padding_16,
        ),
        Container(
          width: double.infinity,
          height: 63,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(AppValues.smallRadius)),
            color: ThemeService().colorScheme.surface,
          ),
          child: CustomText(
            S.current.random_text_841,
            style: TextStyle(color: AppThemes.textColorSecondary, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
