import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/logic.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:get/get.dart';

class TransactionDetailsController extends GetxController {
  TransactionDetailsController();
  /// 当前选中交易类型
  // late TransactionsType selType;
  // late TransactionsCoinType selCoinType;

  _initData() {
    update(["transaction_details"]);
  }

  /// 联系客服
  void customerService() {

  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();
    // TransactionsLogic indexController = Get.find();
    // selType = TransactionsType.all[indexController.selTypeIndex];
    // selCoinType = TransactionsCoinType.all[indexController.selCoinTypeIndex];
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
