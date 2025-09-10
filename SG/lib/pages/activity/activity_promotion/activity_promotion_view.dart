import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/activity/a_helper/activity_biz_helper.dart';
import 'package:flutter_bet/pages/activity/a_widget/promotion_desc_item_widget2.dart';
import 'package:flutter_bet/widget/custom_divider_widget.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_view.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../routes/routes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/app_bar/custom_app_bar_h5.dart';
import '../../../widget/bottom/custom_close_button.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/share/custom_share_widget_list.dart';
import '../../../widget/status/custom_load_loading_view.dart';
import '../a_model/activity_common_params.dart';
import '../a_widget/activity_copy_link_widget.dart';
import '../a_widget/activity_progress_bar_widget.dart';
import '../a_widget/promotion_cond_item_widget.dart';
import '../a_widget/promotion_process_row_widget.dart';
import '../all_promotions/all_promotions_view.dart';
import 'activity_invite_share_dialog.dart';
import 'activity_promotion_logic.dart';

///推广活动页面
///申请通过 之后 顶部可以选择币种，但不界面不刷新。除非拒绝申请
class ActivityPromotionPage extends BaseView<ActivityPromotionLogic> {
  ActivityPromotionPage({Key? key}) : super(key: key);

  ///打开页面, activityState 活动是否进行中
  static openPage(String? pid, ActivityTimeState activityState) {
    RouteUtil.pushToView(Routes.activityPromotions, arguments: {
      "pid": pid,
      "activityState": activityState,
    });
  }


  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
    return CustomAppBar(appBarTitleText: S.current.random_text_927, showLeading: true);
  }

  @override
  Widget buildBody(BuildContext context) {
    return logic.pageLoadingObs.value
        ? CustomLoadLoadingView(
            height: 200, margin: EdgeInsets.only(top: AppValues.barTopHeightLoading))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
            child: CustomScrollView(
              shrinkWrap: true,
              primary: false,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // SliverToBoxAdapter(
                //     child: SizedBox(height: Get.statusBarHeight - AppValues.defaultPadding)),
                // SliverToBoxAdapter(
                //   child: Row(
                //     children: [
                //       Spacer(),
                //       CustomCloseButton(),
                //     ],
                //   ),
                // ),
                SliverToBoxAdapter(child: SizedBox(height: AppValues.barTopHeightMargin)),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      const Spacer(),
                      CustomCloseButton(
                        onTap: () {
                          RouteUtil.popView();
                          AllPromotionsPage.openPage();
                        },
                      )
                    ],
                  ),
                ),
                // SliverToBoxAdapter(child: CustomAppBarH5()),
                SliverToBoxAdapter(child: _buildTopView()),
                SliverToBoxAdapter(
                  child: Visibility(visible: !logic.pbInvite, child: _buildPromotionShareView()),
                ),
                //有效推广人数？（满足以下有所条件）
                SliverToBoxAdapter(child: _buildPromotionCondiView()),
                //福利领取，红包、宝箱
                SliverToBoxAdapter(
                  child: Visibility(visible: !logic.pbInvite, child: _buildPromotionProcessView()),
                ),
                //进度条模式：有效推广人数 0 人
                SliverToBoxAdapter(
                  child: Visibility(visible: logic.pbInvite, child: _buildValidInviteRowViewPB()),
                ),
                //进度条模式：分享
                SliverToBoxAdapter(
                  child: Visibility(visible: logic.pbInvite, child: _buildPromotionProcessViewPB()),
                ),
                SliverToBoxAdapter(child: _buildPromotionDescView()),
                // SliverToBoxAdapter(child: _buildTryBtnView()),
                // SliverToBoxAdapter(child: SizedBox(height: AppValues.defaultMargin)),
                SliverToBoxAdapter(child: SizedBox(height: AppValues.barBottomHeightMargin)),
              ],
            ),
          );
  }

  ///顶部view，推广图片和时间
  Widget _buildTopView() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.margin_8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetWorkImage(
            height: 150.h,
            fit: BoxFit.fill,
            // imageUrl:
            //     "https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg",
            //"image":"promos/zh_CN/1711950305381.webp"
            imageUrl: "${AppValues.defaultBranch.asset_url}/${logic.apiModel.image}",
          ),
          const SizedBox(height: AppValues.margin_24),
          CustomText(
            "${ActivityBizHelper.getIntTimeFormat(logic.apiModel.startAt, secondUnit: true)} - ${ActivityBizHelper.getIntTimeFormat(logic.apiModel.endAt, secondUnit: true)}",
            style: ThemeService()
                .textTheme
                .labelMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          // const SizedBox(height: AppValues.margin_30),
        ],
      ),
    );
  }

  ///推广链接 和 推广分享
  Widget _buildPromotionShareView() {
    return Container(
      margin: EdgeInsets.only(top: AppValues.margin_20),
      padding: const EdgeInsets.all(AppValues.defaultPadding),
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          //推广链接
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                S.current.random_text_533,
                style: ThemeService()
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Obx(() {
                //自动配发 不显示 一键领取 按钮
                return Visibility(
                  // visible: logic.apiModel.isNotAutomatic(),
                  visible: logic.isShowReceiveBtn(),
                  child: CustomButton(
                    // width: double.infinity,
                    title: S.current.vip_commission_receive,
                    isEnable: logic.isEnableReceiveBtn(),
                    alignment: Alignment.center,
                    // textColor:Colors.white,
                    textStyle: ThemeService().textTheme.labelMedium?.copyWith(
                          color:
                              logic.isEnableReceiveBtn() ? Colors.black : const Color(0xFFB5B5B5),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.defaultPadding,
                      vertical: AppValues.padding_4,
                    ),
                    decoration: ShapeDecoration(
                      color: logic.receiveBtnEnableObs.value
                          ? const Color(0xFF00E701)
                          : ThemeService().colorScheme.surfaceVariant,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    onTap: () => logic.onClickOneKeyReceive(),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: AppValues.halfMargin),
          ActivityCopyLinkWidget(
            fullLink: logic.getFullLink(),
            onTapCopy: () => logic.onClickCopyLink(),
          ),
          const SizedBox(height: AppValues.defaultMargin),
          //快捷分享
          InkWell(
            onTap: () => logic.onClickShareMore(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  S.current.random_text_928,
                  style: ThemeService()
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                CustomText(
                  S.current.random_text_153,
                  style: ThemeService()
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: AppValues.margin_4),
                const CustomAssetIcon(
                    name: "assets/images/common/ic_common_arrow_right.webp", size: 12),
              ],
            ),
          ),
          const SizedBox(height: AppValues.halfMargin),
          CustomShareListWidget(shareLinkValue: logic.getFullLink()),
          const SizedBox(height: AppValues.halfMargin),
          const CustomDividerWidget(),
          const SizedBox(height: AppValues.defaultMargin),
          //有效推广人数 0 人
          _buildValidInviteRowView(),
          const SizedBox(height: AppValues.halfMargin),
        ],
      ),
    );
  }

  ///有效推广人数 0 人, 共用view， 不同领取方式 位置不同
  Widget _buildValidInviteRowView() {
    return InkWell(
      onTap: () => logic.onClickInviteDetail(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            // S.current.random_text_929,
            "${S.current.random_text_968}${logic.promotionPeopleObs.value}",
            style: ThemeService()
                .textTheme
                .labelMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          CustomText(
            S.current.detailscopy2,
            style: ThemeService()
                .textTheme
                .labelMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppValues.margin_4),
        ],
      ),
    );
  }

  //推广条件
  Widget _buildPromotionCondiView() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.defaultMargin),
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.defaultPadding, vertical: AppValues.defaultPadding),
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: AppValues.padding_4),
          CustomText(
            // S.current.random_text_930,
            // "${S.current.random_text_1193}${logic.apiModel.getConditionTypeLabel()}",
            "${S.current.random_text_1220}${logic.apiModel.getConditionTypeLabel()}",
            style: ThemeService()
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppValues.padding_4),
          Obx(() {
            return ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: logic.promotionCondListObs.length,
              itemBuilder: (context, index) =>
                  PromotionCondItemWidget(model: logic.promotionCondListObs[index]),
            );
          })
        ],
      ),
    );
  }

  ///推广领取进度流程
  Widget _buildPromotionProcessView() {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.only(top: AppValues.defaultMargin),
        padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeService().colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: logic.processRowListObs.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return PromotionProcessRowWidget(
              index: index,
              showOutsideMoney: logic.apiModel.isShowMoney(),
              rowModelList: logic.processRowListObs[index],
              // onItemClick: (model) => logic.onClickAward(model),
              onItemClick: (model) => logic.doAwardReceive(model: model),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return PromotionProcessRowDividerWidget(index: index);
          },
        ),
      );
    });
  }

  ///推广条件说明
  Widget _buildPromotionDescView() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.defaultMargin),
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.defaultPadding, vertical: AppValues.padding_18),
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            S.current.register_protocol_title,
            style: ThemeService()
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppValues.halfMargin),

          // PromotionDescItemWidget(
          //     title: S.current.random_text_931, content: S.current.random_text_932),
          // PromotionDescItemWidget(
          //     title: S.current.random_text_933, content: S.current.random_text_934),
          // PromotionDescItemWidget(
          //     title: S.current.random_text_935, content: S.current.random_text_936),

          //接口配置
          // CustomText(
          //   logic.apiModel.detail ?? "",
          //   style: ThemeService()
          //       .textTheme
          //       .labelLarge
          //       ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          // ),

          // Html(
          //   data: logic.apiModel.detail ?? "",
          //   //     data: """
          //   // <h1>Hello, World!</h1>
          //   // <p><span style="font-style:italic;">flutter_html</span> supports a variety of HTML and CSS tags and attributes.</p>
          //   // <p>Over a hundred static tags are supported out of the box.</p>
          //   // <p>Or you can even define your own using an <code>Extension</code>: <flutter></flutter></p>
          //   // <p>Its easy to add custom styles to your Html as well using the <code>Style</code> class:</p>
          //   // <p class="fancy">Here's a fancy &lt;p&gt; element!</p>
          //   // """,
          // ),

          //todo:0523, 自己解析处理
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Column(
              children: [
                ...logic.detailObs
                    .map((item) => PromotionDescItemWidget2(
                        title: item.trim(),
                        needReplace: logic.apiModel.needReplace(),
                        highestMoney: logic.apiModel.settings?.last.bonus ?? "0",
                        coinImageUrl: logic.apiCurrentUrlObs.value))
                    .toList(),
              ],
            ),
          ),

          _buildTryBtnView(),
        ],
      ),
    );
  }

  ///天降奖金 存入一笔试试看
  Widget _buildTryBtnView() {
    return Obx(() {
      return Visibility(
        visible: logic.apiModel.showButton(),
        child: Container(
          margin:
              const EdgeInsets.only(top: AppValues.defaultMargin, bottom: AppValues.defaultMargin),
          height: 44,
          // constraints: BoxConstraints.loose(Size.fromWidth(44)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                return CustomButton(
                  // width: double.infinity,
                  // constraints: BoxConstraints.loose(Size.fromHeight(44)),
                  // title: null,
                  title: logic.getPromotionBtnLabel(logic.apiModel.buttonText),
                  alignment: Alignment.center,
                  // textColor:Colors.white,
                  textStyle: ThemeService().textTheme.labelMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.largePadding,
                    vertical: AppValues.padding_4,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF00E701),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  onTap: () => logic.onClickBottomActionBtn(
                    url: logic.apiModel.buttonRedirect,
                    buttonType: int.tryParse(logic.apiModel.buttonType ?? ""),
                  ),
                  // onTap: () => logic.testToast(),
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  //================================ 进度条领取模式 view ================================//

  ///有效推广人数 0 人, 进度条领取模式,PB : progress bar
  Widget _buildValidInviteRowViewPB() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.defaultMargin),
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.defaultPadding, vertical: AppValues.defaultMargin),
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: _buildValidInviteRowView(),
    );
  }

  ///进度条领取模式,PB : progress bar
  Widget _buildPromotionProcessViewPB() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.defaultMargin),
      padding: const EdgeInsets.symmetric(
          horizontal: AppValues.defaultPadding, vertical: AppValues.defaultMargin),
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          _buildInviteItemViewPB(),
          _buildInviteItemViewPB(),
          _buildInviteItemViewPB(),
          //一键领取按钮
          CustomButton(
            // width: double.infinity,
            title: S.current.vip_commission_receive,
            isEnable: logic.receiveBtnEnableObs.value,
            alignment: Alignment.center,
            // textColor:Colors.white,
            textStyle: ThemeService().textTheme.labelMedium?.copyWith(
                  color: logic.receiveBtnEnableObs.value ? Colors.black : const Color(0xFFB5B5B5),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppValues.defaultPadding,
              vertical: AppValues.defaultPadding,
            ),
            decoration: ShapeDecoration(
              color: logic.receiveBtnEnableObs.value
                  ? const Color(0xFF00E701)
                  : ThemeService().colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            onTap: () => logic.onClickOneKeyReceive(),
          ),
        ],
      ),
    );
  }

  ///进度条领取模式 item view
  Widget _buildInviteItemViewPB() {
    return Container(
      padding: const EdgeInsets.all(AppValues.defaultPadding),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          //进度条列
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  S.current.random_text_1165,
                  style: ThemeService()
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 3),
                //进度条
                // Container(
                //   height: 14,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                // ),
                // SizedBox(height: 3),
                ActivityProgressBarWidget(
                  minHeight: 15.h,
                  borderRadius: 10,
                  value: 0.3,
                  content: "3/10",
                ),
                SizedBox(height: 3),
                CustomText(
                  S.current.random_text_1166,
                  style: ThemeService()
                      .textTheme
                      .labelLarge
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppValues.defaultMargin),

          //分享按钮
          InkWell(
            child: Container(
              width: 93.w,
              height: 40.h,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: const Color(0xFF00E701),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: CustomText(
                S.current.random_text_1167,
                style: ThemeService()
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF05080A)),
              ),
            ),
            onTap: () {
              ActivityInviteShareDialog.openDialog(
                copyFullLink: "123123",
                shareFullLink: "SFHAKFJHK",
              );
            },
          )
        ],
      ),
    );
  }
}
