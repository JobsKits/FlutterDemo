import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_images.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/transactions/other.dart';
import 'package:flutter_bet/pages/notifs/widget/notifs_loding.dart';
import 'package:flutter_bet/pages/personal_center/transactions/detail/widgets/text.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/logic.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/widget/item.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/widget/pop_list.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/widget/tabbar.dart';
import 'package:flutter_bet/services/theme/custom_text_theme.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/string_uril.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/custom_top_appbar_view.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/refresh/custom_pull_to_refresh.dart';
import 'package:get/get.dart';

class TransactionsPage extends BaseView<TransactionsLogic> {
  TransactionsPage({super.key});

  final colorScheme = ThemeService().colorScheme;
  final textTheme = ThemeService().theme.textTheme;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleSpacing: 12.0,
      titleView: CustomTopAppBarView(
        isShowLogo: true,
      ),
      showLeading: false,
    );
    // return CustomAppBar(
    //   appBarTitleText: S.current.transaction_records,
    // );
  }

  @override
  Widget buildBody(BuildContext context) {
    return GetBuilder<TransactionsLogic>(
        init: TransactionsLogic(),
        id: "transactions_index",
        builder: (_) {
          controller.ctx = context;

          return SingleChildScrollView(
            controller: controller.scrollController,
            child: <Widget>[
              _buildTransactionsTitle()
                  .paddingHorizontal(AppValues.defaultPadding),

              controller.isTypeListHome ? _buildHome() : _buildHomeList(),

              const SizedBox(height: AppValues.margin_32),
              // CustomText("版权板块").center().height(500)
              //     .backgroundColor(ThemeService().colorScheme.surface),
              const SizedBox(height: 80),
            ].toColumn(),
          );
        });
  }

  /// 交易记录类型选择首页(存款/取款/其它 选择)
  Widget _buildHome() {
    final titleStyle =
        ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

    return <Widget>[
      for (int index = 0; index < controller.typeTitleList.length; index++)
        <Widget>[
          Container(
              width: 3,
              height: 40,
              color: index == 0 ? ThemeService().colorScheme.primary : Colors.transparent),
          const SizedBox(width: AppValues.margin_14),
          CustomText(controller.typeTitleList[index], style: titleStyle)
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center).height(50).onTap(() {
          controller.transactionsTypeDidSelected(index);
        })
    ]
        .toColumn()
        .backgroundColor(ThemeService().colorScheme.surface)
        .clipRRect(all: AppValues.smallRadius)
        .paddingHorizontal(AppValues.defaultPadding);
  }

  /// 交易记录列表首页(存款列表/取款列表/其它列表)
  Widget _buildHomeList() {
    final selType = TransactionsType.allType[controller.selTypeIndex];

    // loding
    final isInitLoding = controller.isInitLoding;

    // 无数据展示判断
    final isNoEntries = controller.itemInfos.isEmpty;

    // 是否展示虚拟币/法币分类
    final isShowCoinBar =
        (selType == TransactionsType.deposits || selType == TransactionsType.withdrawals);

    return <Widget>[
      // 返回 / 存取款 / 筛选
      _buildBackNavView(selType),
      const SizedBox(height: AppValues.defaultPadding),

      <Widget>[
        // 货币切换
        TransactionsTabbar(
          type: TabbarType.coinType,
          titles: controller.coinTypeTitleList,
          selIndex: controller.selCoinTypeIndex,
          callback: controller.coinTypeDidSelected,
        ).visibility(isShowCoinBar),
        const SizedBox(height: AppValues.defaultMargin).visibility(isShowCoinBar),

        // “其他”板块类型选择
        controller.otherTypeTabC == null
            ? const SizedBox()
            : TransactionsTabbar(
                type: TabbarType.otherType,
                titles: controller.otherTypeListTitles,
                selIndex: controller.selOtherTypeIndex,
                callback: controller.otherTypeDidSelected,
                tabController: controller.otherTypeTabC,
              ).visibility(
                selType == TransactionsType.other && controller.otherTypeListTitles.length > 1),

        // Loding
        NotifsLoding()
            .marginAll(AppValues.margin_10)
            .backgroundColor(ThemeService().colorScheme.surface)
            .clipRRect(all: 10)
            .visibility(controller.isInitLoding),

        <Widget>[
          const SizedBox(height: AppValues.defaultPadding)
              .visibility(selType == TransactionsType.other),
          // NoEntries
          _buildNoEntries().visibility(isNoEntries),
          // 列表数据
          _buildHistoryList(selType),
          const SizedBox(height: AppValues.defaultPadding),
          // 上一页/下一页
          _buildListNextPageBtns().visibility(!isNoEntries),
        ].toColumn().visibility(!isInitLoding)
      ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .marginAll(AppValues.margin_10)
          .backgroundColor(ThemeService().colorScheme.surface)
          .clipRRect(all: 10),
    ].toColumn().paddingHorizontal(AppValues.defaultPadding);
  }

  /// 构建title
  Widget _buildTransactionsTitle() {
    return <Widget>[
      const CustomIcon(
          asset: "assets/images/personal_center_icon/transaction_records.webp",
          size: AppValues.iconSize_20),
      const SizedBox(width: AppValues.extraSmallMargin),
      CustomText(S.current.transaction_records,
          style: ThemeService().theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
      const Spacer(),
      const CustomIcon(
              asset: 'assets/images/normal/ic_normal_close.png', size: AppValues.iconDefaultSize)
          .marginOnly(left: AppValues.defaultMargin)
          .center()
          .height(68)
          .onTap(() {
        RouteUtil.popView();
      })
    ].toRow();
  }

  /// 返回NavView
  Widget _buildBackNavView(TransactionsType type) {
    return <Widget>[
      const CustomIcon(
              asset: 'assets/images/setup/ic_left_arrow.png', size: AppValues.iconSmallerSize)
          .marginSymmetric(horizontal: AppValues.defaultMargin)
          .backgroundColor(ThemeService().colorScheme.surface)
          .clipRRect(all: AppValues.smallRadius)
          .onTap(() {
        controller.backTransactionsTypeHome();
      }),

      const SizedBox(width: AppValues.halfPadding),
      // 交易记录类型选择箭头按钮/弹窗（存款/取款/其它）
      TRArrowButtonView(
        titles: controller.typeTitleList,
        selIndex: controller.selTypeIndex,
        callback: (didSelIndex) {
          controller.transactionsTypeDidSelected(didSelIndex);
        },
      ),
      const SizedBox(width: AppValues.halfPadding),
      // 存取款状态筛选箭头按钮及弹窗（全部/成功/失败/进行中）
      TRArrowButtonView(
        titles: controller.stateTypeTitleList,
        selIndex: controller.selStateTypeIndex,
        callback: (didSelIndex) {
          controller.transactionsStateTypeDidSelected(didSelIndex);
        },
      ).visibility(type == TransactionsType.deposits || type == TransactionsType.withdrawals),
    ].toListView(scrollDirection: Axis.horizontal).height(40);
  }

  /// 构建类型交易记录列表
  Widget _buildHistoryList(TransactionsType selType) {
    return ListView.separated(
        itemCount: controller.itemInfos.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: AppValues.defaultPadding);
        },
        itemBuilder: (BuildContext context, int index) {
          final selType = TransactionsType.allType[controller.selTypeIndex];
          switch (selType) {
            case TransactionsType.deposits:
            case TransactionsType.withdrawals:
              return TransactionsWalletItem(type: selType, info: controller.itemInfos[index])
                  .onTap(() => controller.detailDidSelected(index));
            case TransactionsType.other:
              return TransactionsOtherItem(info: controller.itemInfos[index])
                  .onTap(() => controller.detailDidSelected(index));
            default:
              return Container();
          }
        });
  }

  /// 上一页/下一页
  Widget _buildListNextPageBtns() {
    const enableFalseColor = Color(0xff616E81);
    // const enableTrueColor = Color(0xff616E81);
    final enableTrueColor = CustomTextColorStyle.white.value;

    return <Widget>[
      CustomButton(
        textColor: controller.cPage > 1 ? enableTrueColor : enableFalseColor,
        title: S.current.yulecheng_prepage,
        onTap: () => controller.onLastPage(),
      ),
      const SizedBox(
        width: AppValues.defaultPadding,
      ),
      CustomButton(
        textColor:
            controller.itemInfos.length < controller.cPageSize ? enableFalseColor : enableTrueColor,
        title: S.current.yulecheng_nextpage,
        onTap: () => controller.onNextPage(),
      ),
    ].toRow(mainAxisAlignment: MainAxisAlignment.center);
  }

  /// 列表无数据
  Widget _buildNoEntries() {
    final selType = TransactionsType.allType[controller.selTypeIndex];
    final selCoinType = TransactionsCoinType.allType[controller.selCoinTypeIndex];
    var titleText = S.current.no_entries;

    if (selCoinType == TransactionsCoinType.crypto) {
      if (selType == TransactionsType.deposits) {
        titleText = S.current.random_text_592;
      }
      if (selType == TransactionsType.withdrawals) {
        titleText = S.current.random_text_593;
      }
    }
    if (selCoinType == TransactionsCoinType.banking) {
      if (selType == TransactionsType.deposits) {
        titleText = S.current.random_text_594;
      }
      if (selType == TransactionsType.withdrawals) {
        titleText = S.current.random_text_595;
      }
    }

    return <Widget>[
      const CustomAssetIcon(name: AppImages.icStatusViewEmpty, size: AppValues.iconExtraLargerSize),
      CustomText(titleText,
          style: ThemeService()
              .theme
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w400, color: CustomTextColorStyle.secondary.value),
          textColorStyle: CustomTextColorStyle.secondary)
    ].toColumn(mainAxisAlignment: MainAxisAlignment.center).marginSymmetric(vertical: 30).center();
  }
}

/***
 *
 *       // CustomPullToRefresh(
    //         onRefresh: () async {
    //           controller.onRefresh();
    //         },
    //         onLoadMore: () async {
    //           controller.onLoadMore();
    //         },
    //         controller: controller.pullToRefreshController,
    //         noMoreWidget: const SizedBox(),
    //         child: _buildHistoryList(selType))
    //     .visibility(!isNoEntries)
    //     .visibility(!isInitLoding)
    //     .expanded(),
 *
 *
 * ***/
