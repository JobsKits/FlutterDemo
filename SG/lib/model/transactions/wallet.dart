// To parse this JSON data, do
//
//     final trWalletModel = trWalletModelFromJson(jsonString);

import 'package:flutter_bet/generated/l10n.dart';
import 'dart:convert';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:get/get.dart';


List<TrWalletModel> trWalletModelFromJson(String str) => List<TrWalletModel>.from(json.decode(str).map((x) => TrWalletModel.fromJson(x)));

/// 交易记录存/取款
class TrWalletModel {
  String orderNumber;
  int state;
  int createdAt;
  String finallyAmount;
  String? payAmount;
  String currencyId;
  String currencyName;
  String? bankName;
  String? bankAccount;
  String? contractType;
  String? transNo;
  String? walletAddress;
  String? payMethodName;

  TrWalletModel({
    required this.orderNumber,
    required this.state,
    required this.createdAt,
    required this.finallyAmount,
    this.payAmount,
    required this.currencyId,
    required this.currencyName,
    this.bankName,
    this.bankAccount,
    this.contractType,
    this.transNo,
    this.walletAddress,
    this.payMethodName,
  });

  factory TrWalletModel.fromJson(Map<String, dynamic> json) => TrWalletModel(
    orderNumber: json["order_number"],
    state: json["state"],
    createdAt: json["created_at"],
    finallyAmount: json["finally_amount"],
    payAmount: json["pay_amount"],
    currencyId: json["currency_id"],
    currencyName: json["currency_name"],
    bankName: json["bank_name"],
    bankAccount: json["bank_account"],
    contractType: json["contract_type"],
    transNo: json["trans_no"],
    walletAddress: json["wallet_address"],
    payMethodName: json["pay_method_name"],
  );

  /* state状态对应 state:后端状态:前端提示
  * 入款 1:成功:已确认 2:失败:失败, 3:支付中:确认中, 4:删除:失败, 5待审核:确认中, 6:取消:取消
  * 取款 1:成功:已完成 2:拒绝:失败, 3:审核中:处理中, 4:删除:失败, 5三方异常:失败, 6:出款中:处理中
  * */

  /// 状态icon (用于列表item)
  String itemStateIcPath(TransactionsType type) {
    final depositsIconsName = [
      "",
      "assets/images/snack_bar/ic_snack_bar_commission_success.webp",
      "assets/images/snack_bar/ic_snack_bar_error.png",
      coinUrlPath,
      "assets/images/snack_bar/ic_snack_bar_error.png",
      coinUrlPath,
      "assets/images/snack_bar/ic_snack_bar_error.png",
    ];

    final withdrawalsIconsName = [
      "",
      "assets/images/snack_bar/ic_snack_bar_commission_success.webp",
      "assets/images/snack_bar/ic_snack_bar_error.png",
      coinUrlPath,
      "assets/images/snack_bar/ic_snack_bar_error.png",
      "assets/images/snack_bar/ic_snack_bar_error.png",
      coinUrlPath
    ];

    final iconPath = type == TransactionsType.deposits ? depositsIconsName[state] : withdrawalsIconsName[state];
    return iconPath;
  }

  /// 状态icon (用于详情)
  String stateIcPath(TransactionsType type) {

    return itemStateIcPath(type);

    // final depositsIconsName = [
    //   "",
    //   "status_confirmed",
    //   "status_fail",
    //   "status_pending",
    //   "status_fail",
    //   "status_pending",
    //   "status_cancel"
    // ];
    //
    // final withdrawalsIconsName = [
    //   "",
    //   "status_confirmed",
    //   "status_fail",
    //   "status_pending",
    //   "status_fail",
    //   "status_fail",
    //   "status_pending"
    // ];
    //
    // final iconName = type == TransactionsType.deposits ? depositsIconsName[state] : withdrawalsIconsName[state];
    // return "assets/images/personal_center_icon/$iconName.webp";
  }

  /// 状态title (用于列表item)
  String itemStateTitle(TransactionsType type) {

    final depositsTitles = [
      "",
      S.current.random_text_784,
      S.current.random_text_785,
      S.current.random_text_786,
      S.current.random_text_785,
      S.current.random_text_786,
      S.current.random_text_785
    ];
    final withdrawalsTitles = [
      "",
      S.current.random_text_782,
      S.current.random_text_783,
      S.current.random_text_789,
      S.current.random_text_783,
      S.current.random_text_783,
      S.current.random_text_789,
    ];
    return type == TransactionsType.deposits ? depositsTitles[state] : withdrawalsTitles[state];
  }

  /// 状态title (用于详情)
  String stateTitle(TransactionsType type) {

    return itemStateTitle(type);

    // final depositsTitles = [
    //   "",
    //   S.current.transactions_detail_state_confirmed,
    //   S.current.transactions_detail_state_fail,
    //   S.current.transactions_detail_state_confirming,
    //   S.current.transactions_detail_state_fail,
    //   S.current.transactions_detail_state_confirming,
    //   S.current.wallet_cancel
    // ];
    // final withdrawalsTitles = [
    //   "",
    //   S.current.random_text_685,
    //   S.current.transactions_detail_state_fail,
    //   S.current.random_text_686,
    //   S.current.transactions_detail_state_fail,
    //   S.current.transactions_detail_state_fail,
    //   S.current.random_text_686
    // ];
    // return type == TransactionsType.deposits ? depositsTitles[state] : withdrawalsTitles[state];
  }

  /// 货币iconUrl
  String get coinUrlPath {
    final GlobalStateController globalController = Get.find<GlobalStateController>();
    return "${globalController.coinIcDomain}$currencyId.webp";
  }

  /// 日期title
  String get timeTitle {
    // var customFormat = [HH, nn, " ", dd, mm, yyyy];
    // if(LangUtil().isZhCn()) {
    //   customFormat = [HH, nn, " ", yyyy, mm, dd];
    // }
    // return CommonUtil.getLocalTimeTitle(createdAt, cIncludeFormats:[yyyy, mm, dd, HH, nn],
    //     customFormat: customFormat);
    return CommonUtil.getLocalTimeTitle(createdAt);
  }

  /// 金额title获取
  String get amountTitle {
    // 成功状态取带有优惠的总金额finallyAmount
    final temAmount = state == 1 ? finallyAmount : payAmount ?? finallyAmount;
    return MoneyUtil.toCoinAmountFormat(currencyId, temAmount);
  }

  /// TODO: 存款/取款 判断（严谨程度待审查）
  TransactionsType get transactionsType {
    if(walletAddress != null || bankAccount != null) {
      return TransactionsType.withdrawals;
    }
    return TransactionsType.deposits;
  }

  /// TODO: 法币/虚拟币 判断（严谨程度待审查）
  TransactionsCoinType get coinType {
    if(transNo != null) {
      return TransactionsCoinType.crypto;
    }
    return TransactionsCoinType.banking;
  }

}


/*
* 虚拟币入款
*{
        "order_number": "67818154767823874",
        "state": 5,
        "created_at": 1702015761,
        "finally_amount": "5.00000000",
        "currency_id": "709",
        "currency_name": "BNB",
        "trans_no": ""
      },
*
* 法币入款
*  {
        "pay_method_name": "",
        "order_number": "63000646826137198",
        "state": 2,
        "created_at": 1701849640,
        "finally_amount": "101.00000000",
        "currency_id": "702",
        "currency_name": "BRL"
      }
*
*虚拟币取款
*   {
        "order_number": "COIN674336989825443987",
        "state": 3,
        "created_at": 1702002504,
        "finally_amount": "50.00000000",
        "currency_id": "706",
        "currency_name": "USDT",
        "contract_type": "ERC20",
        "trans_no": "",
        "wallet_address": "test12389172987391273912312"
      }

*法币取款
* {
        "order_number": "COIN674331425520176784",
        "state": 3,
        "created_at": 1702002485,
        "finally_amount": "10.00",
        "currency_id": "702",
        "currency_name": "BRL",
        "bank_name": "",
        "bank_account": "ma****.com"
      }
* */
