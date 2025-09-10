import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/pages/personal_center/wallet/widget/custom_password_tip.dart';
import 'package:flutter_bet/widget/status/custom_load_state_view.dart';
import 'package:flutter_bet/widget/status/load_state_config.dart';
import 'package:get/get.dart';

import '../../../app/modules/binding_virtual_address/controllers/binding_virtual_address_controller.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_check_box.dart';
import '../../../widget/custom_rotating_arrow.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/input/custom_main_text_field.dart';
import '../../../widget/network_image/custom_network_image.dart';
import 'auth_widget.dart';

const kCustomBindingVirtualAddressWidget = 'CustomBindingVirtualAddress';
final GlobalKey _globalKeyInput = GlobalKey();
final GlobalKey _globalKeyInputCoin = GlobalKey();
final GlobalKey _globalKeyAddress = GlobalKey();
double bubbleWidth = 114;
const double contractRatio = 1; //协议系数

class BindingVirtualAddress extends StatefulWidget {
  final String? currencyId;

  final List<dynamic>? contractType;

  final String? name;

  final String? selContracts;

  final String? selContractIds;

  final String? flag; // 是否为提款页 1是  2否

  const BindingVirtualAddress({super.key,
    this.currencyId,
    this.contractType,
    this.name,
    this.flag,
    this.selContracts,
    this.selContractIds});

  @override
  State<StatefulWidget> createState() {
    return _BindingVirtualAddressState();
  }
}

class _BindingVirtualAddressState extends State<BindingVirtualAddress>
    with SingleTickerProviderStateMixin {
  late BindingVirtualAddressController controller = Get.find<BindingVirtualAddressController>();

  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<RotatingArrowState> _rotatingCoinArrowKey = GlobalKey<RotatingArrowState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<BindingVirtualAddressController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Material(
      color: Colors.transparent,
      child: rootView(),
    );
  }

  Widget rootView() {
    return Obx(() {
      return CustomLoadStateLayout(
        configType: LoadStateConfigType.def,
        configState: controller.viewState.value,
        showEmptyRetry: false,
        showErrorRetry: false,
        configSuccess: contentView(),
      );
    });
  }

  Widget contentView() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      // decoration: BoxDecoration(
      //   borderRadius: const BorderRadius.all(Radius.circular(4)),
      //   color: ThemeService().colorScheme.background,
      // ),
      //   decoration: BoxDecoration(
      //       border: Border.all(color: ThemeService().colorScheme.tertiary, width: 1),
      //       borderRadius: BorderRadius.all(
      //         Radius.circular(4),
      //       )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 货币
          CustomAsterisksTipsText(
            text: S.current.wallet_currency,
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.flag == "1") {
                    return;
                  }
                  if ((controller.coinSelected.value.name ?? "").isEmpty) {
                    return;
                  }
                  if (controller.withDrawCtrl.previousBottomInset > 0) {
                    FocusScope.of(Get.context!).requestFocus(FocusNode());
                  } else {
                    _startAnimation(_rotatingCoinArrowKey);
                    DialogUtils.showCustomBubbleDialog(
                        context, _selectCoin(context), _getInputWidth(),
                        widgetKey: _globalKeyInputCoin,
                        backgroundColor: AppThemes.widgetColorWhite,
                        bubbleArrowHeight: 8,
                        bubbleArrowWidth: 8,
                        globalKey: _rotatingCoinArrowKey);
                  }
                },
                child: Obx(() {
                  return CustomMainTextField(
                    // hintText: widget.flag == "1"
                    //     ? widget.selContracts ?? ""
                    //     : controller.selContract.value.isNotEmpty
                    //         ? controller.selContract.value
                    //         : "",
                    text: "\t\t\t\t\t${controller.coinSelected.value.name ?? controller.name}",
                    textColor: (controller.coinSelected.value.name ?? "").isEmpty
                        ? Colors.grey
                        : Colors.white,
                    enabled: false,
                    key: _globalKeyInputCoin,
                  );
                }),
              ),
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 10,
                  child: controller.adrId == ""
                      ? Obx(() {
                    return CustomNetWorkImage(
                      placeholder: const CustomAssetIcon(
                        name: 'assets/images/personal_center_icon/pay_default_ic.webp',
                      ),
                      errorWidget: const CustomAssetIcon(
                        name: 'assets/images/personal_center_icon/pay_default_ic.webp',
                      ),
                      fit: BoxFit.fitWidth,
                      imageUrl: controller.coinSelected.value.coinImgUrl,
                      width: 18,
                      height: 18,
                    );
                  })
                      : CustomNetWorkImage(
                    //edit ic
                    placeholder: const CustomAssetIcon(
                      name: 'assets/images/personal_center_icon/pay_default_ic.webp',
                    ),
                    errorWidget: const CustomAssetIcon(
                      name: 'assets/images/personal_center_icon/pay_default_ic.webp',
                    ),
                    fit: BoxFit.fitWidth,
                    imageUrl:
                    "${AppValues.defaultBranch.asset_url}/currency/${controller
                        .currencyId}${controller.coinIcExtensionName}",
                    width: 18,
                    height: 18,
                  )),
              Positioned(
                  right: 0,
                  child: Visibility(
                    visible: widget.flag == "1" ? false : true,
                    child: Container(
                      height: AppValues.defaultTextHeight,
                      margin: const EdgeInsets.only(right: 9),
                      child: RotatingArrow(
                        key: _rotatingCoinArrowKey,
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: AppValues.margin_12,
          ),

          /// 协议
          Visibility(
            //https://jira.vgtech.org/browse/STAK-847
            visible: widget.flag == "1" ? false : true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //https://jira.vgtech.org/browse/STAK-2796 暂时不要删除
                // CustomText(
                //   S.current.binding_selectAgreement,
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                //   style: ThemeService().textTheme.bodyMedium?.copyWith(
                //       fontWeight: FontWeight.w500),
                //   textColorStyle: CustomTextColorStyle.normal,
                // ),
                CustomAsterisksTipsText(
                  text: S.current.random_text_643,
                ),
                const SizedBox(
                  height: 4,
                ),
                Stack(
                  children: [
                    GestureDetector(onTap: () {
                      if (widget.flag == "1") {
                        return;
                      }
                      if ((controller.coinSelected.value.name ?? "").isEmpty) {
                        return;
                      }
                      if (controller.withDrawCtrl.previousBottomInset > 0) {
                        FocusScope.of(Get.context!).requestFocus(FocusNode());
                      } else {
                        _startAnimation(_rotatingArrowKey);
                        DialogUtils.showCustomBubbleDialog(
                            context, _selectContract(context), _getInputWidth(),
                            widgetKey: _globalKeyInput,
                            backgroundColor: AppThemes.widgetColorWhite,
                            bubbleArrowHeight: 8,
                            bubbleArrowWidth: 8,
                            globalKey: _rotatingArrowKey);
                      }
                    }, child: Obx(() {
                      print("neco请勿删除 如果删除将报错哦${controller.selContract.value}");
                      return CustomMainTextField(
                        text: widget.flag == "1"
                            ? widget.selContracts ?? ""
                            : controller.selContract.value.isNotEmpty
                            ? controller.selContract.value
                            : "",
                        enabled: false,
                        textColor: (controller.coinSelected.value.name ?? "").isEmpty
                            ? Colors.grey
                            : Colors.white,
                        key: _globalKeyInput,
                      );
                    })),
                    Positioned(
                        right: 0,
                        child: Visibility(
                          visible: widget.flag == "1" ? false : true,
                          child: Container(
                            height: AppValues.defaultTextHeight,
                            margin: const EdgeInsets.only(right: 9),
                            child: RotatingArrow(
                              key: _rotatingArrowKey,
                            ),
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: AppValues.margin_12,
                ),
              ],
            ),
          ),
          //https://jira.vgtech.org/browse/STAK-2796 暂时不要删除
          // Obx(() {
          //   print("neco请勿删除 如果删除将报错哦${controller.selContract.value}");
          //   return RichText(
          //       text: TextSpan(children: [
          //         TextSpan(
          //           text: S.current.binding_your(controller.name),
          //           style: ThemeService()
          //               .theme
          //               .textTheme
          //               .bodyMedium
          //               ?.copyWith(color: CustomTextColorStyle.normal.value),
          //         ),
          //         TextSpan(
          //           text: "${widget.flag== "1"? widget.selContracts: controller.selContract}",
          //           style: ThemeService()
          //               .theme
          //               .textTheme
          //               .bodyMedium
          //               ?.copyWith(color: CustomTextColorStyle.orange.value),
          //         ),
          //         TextSpan(
          //           text: S.current.vault_address,
          //           style: ThemeService()
          //               .theme
          //               .textTheme
          //               .bodyMedium
          //               ?.copyWith(color: CustomTextColorStyle.normal.value),
          //         ),
          //         TextSpan(
          //           text: "*",
          //           style: ThemeService()
          //               .theme
          //               .textTheme
          //               .bodyMedium
          //               ?.copyWith(color: CustomTextColorStyle.error.value),
          //         ),
          //       ]));
          // }),
          ///钱包地址
          CustomAsterisksTipsText(
            // text: S.current.random_text_644,
            text: S.current.random_text_1126,
          ),
          const SizedBox(
            height: 4,
          ),
          Obx(() {
            return CustomMainTextField(
              hintText: S.current.random_text_1126,
              showError: controller.showAddressError.value,
              // hintText: S.current.binding_bank_card_please_enter,
              text: controller.addressText.value,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              ],
              inputCallBack: (str) {
                controller.address = str;
                controller.addressText.value = str;
                if (str.isNotEmpty) {
                  controller.showAddressError.value = false;
                  controller.addressErrorText.value = '';
                }
              },
              errorText: controller.addressErrorText.value,
              focusNode: controller.focusNodeAddress,
            );
          }),
          const SizedBox(
            height: AppValues.margin_12,
          ),
          _passWordWidget(isAuthView: true),
          const SizedBox(
            height: AppValues.margin_12,
          ),
          Obx(() {
            return Row(
              children: [
                GestureDetector(
                    onTap: () {
                      controller.isDefault.value = !controller.isDefault.value;
                    },
                    child: CustomCheckBox(
                      iconSize: 16,
                      value: controller.isDefault.value,
                    )),
                const SizedBox(
                  width: 4,
                ),
                CustomText(S.current.binding_setAsDefaultAddress,
                    textColorStyle: CustomTextColorStyle.normal),
              ],
            );
          }),
          const SizedBox(
            height: 24,
          ),
          CustomText(
            S.current.random_text_638,
            textColorStyle: CustomTextColorStyle.normal,
          ),

          const SizedBox(
            height: AppValues.margin_12,
          ),
          CustomBigMainButton(
            fontWeight: FontWeight.w600,
            colorStyle: CustomButtonColorStyle.tertiary,
            onTap: (customButtonController) {
              controller.checkAddress(controller.addressText.value);
              controller.checkInputPassWord();
              if (controller.showAddressError.value || controller.inputPassWordShowError.value) {
                return;
              }
              //需求变更 暂时注释
              // if (controller.getIsSetupPassword() == false) {
              //   showCustomPromptToPwWidget(context: context);
              //   return;
              // }
              // showCustomPassWorldWidget(context: context, isBindBank: 3);
              controller.walletInsert(context, customButtonController, controller.id);
            },
            title: widget.flag == "1" ? S.current.submit_text : S.current.random_text_1288,
          ),
          Obx(() {
            return Visibility(
                visible: controller.isCertified.value == true && widget.flag == "1",
                child: const AuthWidget());
          })
        ],
      ),
    );
  }

  _init() {
    Get.lazyPut(() => BindingVirtualAddressController());

    if ((widget.currencyId ?? "").isNotEmpty) {
      controller.currencyId = widget.currencyId ?? "";
      controller.id = widget.currencyId ?? "";
    }

    if ((widget.selContracts ?? "").isNotEmpty) {
      controller.selContracts = widget.selContracts ?? "";
    }

    if ((widget.selContractIds ?? "").isNotEmpty) {
      controller.selContractIds = widget.selContractIds ?? "";
    }

    if ((widget.contractType ?? []).isNotEmpty) {
      controller.contractType = widget.contractType ?? [];
      for (int i = 0; i < controller.contractType.length; i++) {
        if (i == 0) {
          controller.contractType[0]['isSelect'] = true;
        } else {
          controller.contractType[i]['isSelect'] = false;
        }
      }
      controller.selContract.value = controller.contractType[0]['label'];
      controller.selContractId.value = controller.contractType[0]['id'];
    }

    if ((widget.name ?? "").isNotEmpty) {
      controller.name = widget.name ?? "";
    }

    controller.flag = widget.flag;

    controller.addressText.value = ""; //清空数据
    controller.showAddressError.value = false;
    controller.focusNodeAddress.addListener(() {
      if (!controller.focusNodeAddress.hasFocus && widget.flag != "1") {
        controller.checkAddress(controller.addressText.value);
      }
    });
  }

  // for (var bean in GlobalStateController.of().currTypeInitialLists) {
  // coinListTemp.add(CustomSelectModel(bean.name ?? "", data: bean.cur));
  // }
  // final coinList = GlobalStateController.of().localConfigCoinLists;
  ///货币选择 下拉列表
  Widget _selectCoin(BuildContext context) {
    return Obx(() {
      return Container(
        color: Colors.transparent,
        constraints: const BoxConstraints(maxHeight: 300),
        child: SingleChildScrollView(
          child: Column(
            children: controller.coinList.map((coinBean) {
              return GestureDetector(
                  onTap: () {
                    // for (int i = 0; i < controller.coinList.length; i++) {
                    //   controller.coinList[i]['isSelect'] = false;
                    // }
                    // var isSelect = contract["isSelect"] ?? false;
                    // contract["isSelect"] = isSelect ? false : true;
                    // controller.selContract.value = contract['label'];
                    // controller.selContractId.value = contract['id'];
                    controller.onClickCoinItem(coinBean);
                    Get.back();
                  },
                  child: Container(
                      padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
                      color: coinBean == controller.coinSelected.value
                          ? AppThemes.textColorSecondary
                          : Colors.transparent,
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Row(
                        children: [
                          CustomNetWorkImage(
                            imageUrl: coinBean.coinImgUrl,
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(width: AppValues.margin_4),
                          CustomText(
                            coinBean.name ?? "",
                            textColorStyle: CustomTextColorStyle.dark,
                          ),
                        ],
                      )));
            }).toList(),
          ),
        ),
      );
    });
  }

  ///合约下拉列表
  Widget _selectContract(BuildContext context) {
    return Container(
      color: Colors.transparent,
      constraints: const BoxConstraints(maxHeight: 220),
      child: SingleChildScrollView(
        child: Column(
          children: controller.contractType.map((contract) {
            return GestureDetector(
                onTap: () {
                  for (int i = 0; i < controller.contractType.length; i++) {
                    controller.contractType[i]['isSelect'] = false;
                  }
                  var isSelect = contract["isSelect"] ?? false;
                  contract["isSelect"] = isSelect ? false : true;
                  controller.selContract.value = contract['label'];
                  controller.selContractId.value = contract['id'];
                  Get.back();
                },
                child: Container(
                    padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
                    color: contract['isSelect'] == true
                        ? AppThemes.textColorSecondary
                        : Colors.transparent,
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: CustomText(
                      contract['label'],
                      textColorStyle: CustomTextColorStyle.dark,
                    )));
          }).toList(),
        ),
      ),
    );
  }

  //资金密码
  Widget _passWordWidget({bool isAuthView = false}) {
    return Visibility(
        visible: isAuthView,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CustomAsterisksTipsText(text: S.current.wallet_fundPassword),
            Obx(() {
              return CustomAsterisksTipsText(
                  text: controller.pwdTypeBean.isNotEmpty ? controller.pwdTypeBean['title'] : "");
            }),
            const SizedBox(
              height: AppValues.margin_4,
            ),
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Obx(() {
                        return CustomMainTextField(
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: controller.getBoxDecoration(
                              showErr: controller.inputPassWordShowError.value),
                          hintText: controller.pwdTypeBean.isNotEmpty
                              ? controller.pwdTypeBean['title']
                              : "",
                          isUpdatePsdOffset: true,
                          showError: controller.inputPassWordShowError.value,
                          // errorText: controller.inputPassWordShowErrorText.value,
                          maxLength: 6,
                          isPwd: true,
                          text: controller.inputPassWord.value,
                          inputCallBack: (str) {
                            controller.inputPassWord.value = str;
                            controller.checkInputPassWord();
                          },
                        );
                      }),
                    ],
                  ),
                ),
                Container(
                  width: controller.globalController.isChinese() ? 100 : 126,
                  height: AppValues.defaultTextHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ThemeService().colorScheme.tertiaryContainer,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
                  child: CustomPasswordTips(
                    onPwdTypeSelected: (selectedPwdType) {
                      controller.pwdTypeBean.value = selectedPwdType;
                      controller.inputPassWordShowErrorText.value =
                          S.current.binding_bank_card_please_enter +
                              "${controller.pwdTypeBean["title"]}";
                      log("neco  密码配置 ${controller.pwdTypeBean['title']}");
                    },
                  ),
                )
              ],
            ),
            Obx(() {
              return errorView();
            }),
          ],
        ));
  }

  Widget errorView() {
    return controller.errView(
        controller.inputPassWordShowError.value, controller.inputPassWordShowErrorText.value);
  }

  double _getInputWidth() {
    // 使用 GlobalKey 获取弹窗的 RenderBox
    final RenderBox renderBox = _globalKeyInput.currentContext!.findRenderObject() as RenderBox;
    // 获取 RenderBox 的大小
    final Size size = renderBox.size;
    return size.width;
  }
}

Future<void> showCustomBindingVirtualAddressWidget<T>({
  required BuildContext context,
  required String currencyId,
  required String currencyName,
  required List<dynamic> contractType,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomBindingVirtualAddressWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            BindingVirtualAddress(
              key: _globalKeyAddress,
              // id: currencyId,
              // name: currencyName,
              // contractType: contractType,
            ),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
