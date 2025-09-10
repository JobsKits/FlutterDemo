import 'package:flutter/material.dart';
import 'package:flutter_bet/model/wallet/PayChannelBean.dart';
import 'package:flutter_bet/model/wallet/PayWayBean.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../controllers/wallet_controller.dart';

class PaymentMethodView extends GetView<WalletCtrl> {
  const PaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _payView();
    });
  }

  Widget _payView() {
    return Container(
      decoration: BoxDecoration(
          color: ThemeService().colorScheme.surface, borderRadius: BorderRadius.circular(6.0)),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: controller.payList.length,
        itemBuilder: (BuildContext context, int index) {
          int chCt = controller.payList[index].merchants?.length ?? 0;
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(left: 14, right: 14, top: 6),
                title: CustomText(
                  '${controller.payList[index].name}',
                  textColorStyle: CustomTextColorStyle.normal,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ).marginOnly(bottom: 6),
                subtitle: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.payList[index].showAllCh
                      ? chCt
                      : controller.showChCt(controller.payList.length, chCt), //3
                  itemBuilder: (BuildContext context, int subIndex) {
                    var payChannelBean = controller.payList[index].merchants![subIndex];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: InkWell(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xff2F4553),
                              borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Stack(
                            children: [
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 2),
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      color: controller
                                          .getMarkBg(controller.payList[index].ptype ?? 0),
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(3),
                                          bottomLeft: Radius.circular(4)),
                                    ),
                                    child: CustomText(
                                      controller.getMarkValue(
                                          controller.payList[index].pname ?? "",
                                          controller.payList[index].promo ?? "",
                                          controller.payList[index].ptype ?? 0),
                                      style: const TextStyle(
                                          fontSize: 11, fontWeight: FontWeight.w600),
                                      textColorStyle: CustomTextColorStyle.white,
                                    ),
                                  )),
                              Row(
                                children: [
                                  Container(
                                    height: 55,
                                    padding: const EdgeInsets.only(left: 18, right: 18),
                                    decoration: const BoxDecoration(
                                        color: Color(0xff213744),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5))),
                                    child: Obx(() {
                                      return getIcon(controller.payList[index], payChannelBean);
                                    }),
                                  ),
                                  const SizedBox(
                                    width: 9,
                                  ),
                                  SizedBox(
                                      width: 78,
                                      child: CustomText(
                                        payChannelBean.name ?? "",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500, fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  Expanded(
                                    child: Wrap(
                                      alignment: WrapAlignment.end,
                                      children: [
                                        CustomText(
                                          '${payChannelBean.amountMin} - ${payChannelBean.amountMax} ${controller.getMergerSelCoin(controller.fiatCurrTabSel.value).name}',
                                          textColorStyle: CustomTextColorStyle.normal,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500, fontSize: 12),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Transform.rotate(
                                    angle: -90 * 3.141592653589793 / 180,
                                    child: const CustomAssetIcon(
                                      name: "assets/images/top_drop_down arrow.png",
                                      size: 14,
                                      color: Color(0xffa6b2cb),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          controller.saveSelectedPaymentMet(controller.payList[index].merchants,
                              subIndex, controller.payList[index]);
                        },
                      ),
                    );
                  },
                ),
              ),
              if (controller.showChCt(controller.payList.length, chCt) != chCt)
                InkWell(
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomText(
                      controller.payList[index].showAllCh
                          ? S.current.random_text_666
                          : S.current.random_text_1138,
                      textColorStyle: CustomTextColorStyle.normal,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ).marginOnly(bottom: 6),
                  onTap: () => {
                    controller.payList[index].showAllCh = !controller.payList[index].showAllCh,
                    controller.payList.refresh(),
                  },
                )
            ],
          );
        },
      ),
    );
  }

  getIcon(PayWayBean payWayBean, PayChannelBean channelBean) {
    if (controller.fiatCurrTabSel.value) {
      return CustomNetWorkImage(
        fit: BoxFit.fitWidth,
        placeholder: const CustomAssetIcon(
          name: 'assets/images/personal_center_icon/pay_default_ic.webp',
        ),
        errorWidget: const CustomAssetIcon(
          name: 'assets/images/personal_center_icon/pay_default_ic.webp',
        ),
        width: 24,
        height: 24,
        imageUrl:
            "${controller.payIcDomain}${controller.getChlIc(payWayBean)}${channelBean.alias}${controller.coinIcExtensionName}",
      );
    } else {
      return CustomNetWorkImage(
        placeholder: const CustomAssetIcon(
          name: 'assets/images/personal_center_icon/pay_default_ic.webp',
        ),
        errorWidget: const CustomAssetIcon(
          name: 'assets/images/personal_center_icon/pay_default_ic.webp',
        ),
        fit: BoxFit.fitWidth,
        imageUrl: controller.getMergerSelCoin(controller.fiatCurrTabSel.value).coinImgUrl,
        width: 18,
        height: 18,
      );
    }
  }
}
