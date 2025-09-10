import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/betting/common_helper/betting_biz_helper.dart';
import 'package:flutter_bet/pages/sport/sport_detail/model.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/function.dart';
import '../../../../utils/odds_util.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_error_tips_text.dart.dart';
import '../../../../widget/custom_number_keyboard.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/textinput/text_input_focus_node.dart';
import '../../../personal_center/vault/deposit_view.dart';

class SportSingleBetItem extends StatefulWidget {
  SportSingleBetItem({
    super.key,
    required this.bean,
    required this.decimalLength,
    required this.deleteBet,
    required this.onChanged,
    required this.onScrollTo,
    required this.isLogin,
    this.onOpenInputText,
    this.onCloseInputText,
  });

  final M bean;
  final int decimalLength; //小数点
  final VoidCallback deleteBet;
  final ParamSingleCallback<String> onChanged;
  final ParamVoidCallback onScrollTo;
  final bool isLogin;

  final void Function(num? amount)? onOpenInputText;
  final void Function(num? amount)? onCloseInputText;

  @override
  State<StatefulWidget> createState() => _SportSingleBetItemState();
}

class _SportSingleBetItemState extends State<SportSingleBetItem>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool isIconVisible = false; // 控制图标的可见性
  bool isOddsUp = true; //赔率上升还是下降
  final TextInputFocusNode _focusNode = TextInputFocusNode();
  late String inputText;
  final isOpenEdit = false.obs; //是否是编辑状态,基本逻辑：处于编辑状态的使用inputText， 非编辑状态使用amount

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _focusNode.canRequestFocus = false;
    if (widget.bean.amount != 0) {
      inputText = '${widget.bean.amount}';
    } else {
      inputText = '';
    }
    // log("单项投注item...initState()...inputText...$inputText");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // log("单项投注item信息...${JsonUtil.encodeObj(widget.bean)}");
    // log("单项投注item...build()...isOpenEdit...${isOpenEdit}");
    // log("单项投注item...build()..._focusNode...${_focusNode.canRequestFocus}");
    // log("单项投注item...build()...amount...${widget.bean.amount.toString()}");
    return Opacity(
      opacity: widget.bean.es == 2 || widget.bean.os == 0 || widget.bean.rbts == 3 ? 0.5 : 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            _buildTitleView(),
            _buildContentView(),
            Container(
              height: AppValues.defaultPadding,
              color: ThemeService().colorScheme.surfaceVariant,
            ),
            Image.asset('assets/images/bet_slip/ic_bet_item_wave.webp'),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleView() {
    return Container(
      height: 30,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: widget.bean.showState == 2
              ? AppThemes.noBettingAllowedColor
              : ThemeService().colorScheme.tertiary,
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
      child: Row(
        children: [
          _buildTitleState(),
          const SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onTap: () {
                // SportDetailPage.openPage(si: widget.bean.si, eid: widget.bean.ei);
              },
              child: CustomText(
                ///赛事名称
                // '${widget.bean.htn} - ${widget.bean.atn}',
                BettingBizHelper.getBetInfoTeamNameLabel(widget.bean),
                // '了快点结束立刻就收到了空间的开始顺利的结束是颠三倒四了',
                style: ThemeService().textTheme.labelLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
              onTap: () {
                widget.deleteBet.call();
              },
              child: const CustomAssetIcon(
                name: 'assets/images/bet_slip/ic_close_bet.webp',
                size: 18,
              )),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildTitleState() {
    if (widget.bean.showState == 0) {
      return Visibility(
        ///滚球 1:早盘 2:今日 3:滚球
        visible: widget.bean.m == 3,
        child: Container(
          margin: const EdgeInsets.only(left: 12),
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
          decoration: BoxDecoration(
              color: AppThemes.reverseStateColor, borderRadius: BorderRadius.circular(2)),
          child: CustomText(
            S.current.bet_live,
            style: ThemeService().textTheme.bodySmall,
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(left: 12),
        child: CustomAssetIcon(
            name: widget.bean.showState == 1
                ? 'assets/images/bet_slip/ic_bet_done.png'
                : 'assets/images/bet_slip/ic_bet_wrong.webp'),
      );
    }
  }

  Widget _buildContentView() {
    var toast_text =
        '${S.current.binding_bank_card_please_enter}${widget.bean.min ?? 0}-${widget.bean.max ?? 100000000}${S.current.random_text_243}';
    if (LangUtil().isTh()) {
      toast_text =
          '${S.current.binding_bank_card_please_enter}${S.current.random_text_243} ${widget.bean.min ?? 0}-${widget.bean.max ?? 100000000}';
    }else if (LangUtil().isViVn()) {
      toast_text =
      'Vui lòng nhập số tiền giữa khoảng ${widget.bean.min ?? 0}-${widget.bean.max ?? 100000000}';
    }
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: ThemeService().colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 5,
          ),
          CustomText(
            ///获胜方式
            widget.bean.btn ?? '',
            style: ThemeService().textTheme.labelLarge,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: CustomText(
                  ///获胜球队(暂时为主队名称)
                  widget.bean.sn ?? '',
                  style: ThemeService().textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 10,
              ),

              ///赔率
              Stack(
                children: [
                  Visibility(
                      // visible: widget.bean.es == 1 && widget.bean.os != 0 && widget.bean.rbts != 3,
                      visible: BettingBizHelper.isBetOpening(widget.bean),
                      child: Row(
                        children: [
                          // CustomSportOddChangeAnimation(value,isOddsUp: isOddsUp, isIconVisible: isIconVisible,),
                          // Image.asset('assets/images/bet_slip/ic_odds_up.webp'),
                          const SizedBox(
                            width: 5,
                          ),
                          CustomText(
                            OddsUtil().covertOdds(double.parse(widget.bean.ov!)) ?? '',
                            style: ThemeService()
                                .theme
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ThemeService().colorScheme.secondary),
                          ),
                        ],
                      )),
                  //暂停 or 已关闭
                  Visibility(
                      // visible: widget.bean.rbts == 3 || widget.bean.es == 2 || widget.bean.os == 0,
                      visible: BettingBizHelper.isBetClosed(widget.bean),
                      child: CustomText(
                        widget.bean.rbts == 3 ? S.current.bet_stop : S.current.bet_settled,
                        style: const TextStyle(color: AppThemes.reverseStateColor),
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          ///投注成功
          Visibility(
            visible: widget.bean.showState == 0,
            child: Container(
              height: 39,
              child: Row(
                children: [
                  //输入金额
                  _buildTextField(),
                  const Spacer(),
                  //显示预支付金额
                  _buildBetPayView(),
                ],
              ),
            ),
          ),
          Visibility(
              visible: checkAmount(),
              child: Padding(
                padding: const EdgeInsets.only(top: AppValues.smallPadding),
                child: CustomErrorTipsText(text: toast_text),
              )),
        ],
      ),
    );
  }

  ///显示预支付金额
  _buildBetPayView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(
          S.current.bet_pay,
          style: ThemeService().textTheme.labelMedium,
        ),
        SizedBox(height: 4),
        //显示金额
        Row(
          children: [
            CustomText(
              widget.bean.amount.toString(),
              style: ThemeService().textTheme.labelMedium,
            ),
            SizedBox(width: 8),
            CustomNetWorkImage(
                width: 14,
                height: 14,
                imageUrl: globalController.currTypeSelected.value.coinIc ?? "",
                errorWidget: const CustomAssetIcon(
                  name: 'assets/images/bet_slip/ic_defalut_coin.png',
                  size: 14,
                )),
          ],
        )
      ],
    );
  }

  ///投注额输入框
  Widget _buildTextField() {
    // log('单项投注金额：${widget.bean.amount}');
    return GestureDetector(
      onTap: () {
        openInputText(widget.bean.amount);
        widget.onScrollTo();
        if (widget.bean.es == 2 || widget.bean.os == 0 || widget.bean.rbts == 3) {
        } else {
          if (widget.onOpenInputText != null) {
            widget.onOpenInputText!(widget.bean.amount);
          }
          showModalBottomSheet(
            context: context,
            barrierColor: Colors.transparent,
            isDismissible: true,
            builder: (BuildContext context) {
              return CustomNumberKeyboard(
                margin: EdgeInsets.only(bottom: AppValues.barBottomHeight - 2),
                onKeyPressed: handleKeyboardInput,
              );
            },
          ).then((value) {
            //关闭回调，应该调用一下计算方法
            //如果是0 ，补小数点
            closeInputText();
            if (widget.onCloseInputText != null) {
              widget.onCloseInputText!(value);
            }
          });
        }
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
            color: ThemeService().theme.colorScheme.tertiary,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: checkAmount() ? Colors.red : Colors.transparent, width: 2.0)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 36,
                padding: const EdgeInsets.only(left: AppValues.defaultPadding, right: 5),
                alignment: Alignment.centerLeft,
                child: Obx(() {
                  return CustomText(
                    // '${widget.bean.amount}',
                    //  区分编辑状态，处于编辑状态的使用inputText， 非编辑状态使用amount
                    dealInputText(widget.bean.amount, inputText, widget.decimalLength),
                    style: ThemeService().textTheme.bodyMedium!.copyWith(
                        color: !widget.isLogin && widget.bean.amount == 0
                            ? AppThemes.textColorGrey
                            : null),
                  );
                }),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: AppValues.margin_12),
              child: CustomNetWorkImage(
                  width: 14,
                  height: 14,
                  imageUrl: globalController.currTypeSelected.value.coinIc ?? "",
                  errorWidget: const CustomAssetIcon(
                    name: 'assets/images/bet_slip/ic_defalut_coin.png',
                    size: 14,
                  )),
            )
          ],
        ),
      ),
    );
  }

  ///打开键盘时 处理inputText 显示，是什么就显示什么
  String openInputText(num? amount) {
    // log("单项投注item...键盘打开()...amount...${amount}");
    //amount 如果为null 或者0 inputText直接不显示。在关闭键盘做特殊处理即可
    inputText = '${(amount != null && amount > 0) ? amount : ''}';
    isOpenEdit.value = true;
    return inputText;
  }

  ///关闭键盘
  String closeInputText() {
    //关闭回调，应该调用一下计算方法
    //如果是0 ，补小数点
    isOpenEdit.value = false;
    // inputText =
    //     BettingBizHelper.dealSingleInputDecimalWithStr(inputText, widget.decimalLength);
    // log("单项投注item...键盘收起()...inputText...${inputText}");
    return inputText;
  }

  ///区分编辑状态，处于编辑状态的使用inputText， 非编辑状态使用amount
  ///未登录状态下，待投注项金额输入框内的提示金额显示样式我们统一显示0.00...，
  ///小数的位数根据币种保留的金额小数位数来显示（用暗色的字体颜色）
  String dealInputText(num? amount, String? inputText, int decimalLength) {
    if (!widget.isLogin && !isOpenEdit.value) {
      return BettingBizHelper.dealSingleInputDecimal(amount, decimalLength);
    } else {
      if (isOpenEdit.value) {
        return '$inputText';
      } else {
        return '$amount';
      }
    }
  }

  void handleKeyboardInput(String key) {
    if (key == 'delete') {
      // 处理删除逻辑
      // if (inputText.isNotEmpty && inputText != '0') {
      //   final text = inputText;
      //   inputText = text.substring(0, text.length - 1);
      // } else {
      //   inputText = '0';
      // }
      //直接删除
      if (inputText.isNotEmpty) {
        final text = inputText;
        inputText = inputText.substring(0, text.length - 1);
      }
      // log("单项投注item...delete...inputText...$inputText");
    } else if (key == 'OK') {
      Navigator.of(context).pop();
    } else if (key == '.') {
      if (!inputText.contains('.')) {
        inputText += key;
      }
    } else {
      if (inputText == '0') {
        inputText = key;
      } else {
        // 处理其他数字输入
        inputText += key;
      }
    }

    //回调在之前进行处理
    if (inputText.isEmpty) {
      widget.onChanged("0");
    } else {
      widget.onChanged(inputText);
    }
  }

  bool checkAmount() {
    if (widget.bean.amount != 0.00) {
      return widget.bean.amount! < (widget.bean.min ?? 0) ||
          widget.bean.amount! > (widget.bean.max ?? 1000000000);
    }
    return false;
  }
}
