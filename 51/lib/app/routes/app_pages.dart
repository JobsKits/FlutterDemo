import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/leaderboard_reward_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/relief_fund_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/welcome_bonus_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_discount_records_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_discount_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/leaderboard_reward_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/relief_fund_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/welcome_bonus_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_turntable_detail.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/collection/activity_collection_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/rebate_new/rebate_proportion_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/rebate_new/rebate_record_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/rebate_new/rebate_record_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/vip/vip_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/vip/controller/vip_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/vip/vip_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E4%BC%9A%E5%91%98%E6%8A%A5%E8%A1%A8/agent_center_member_report_view.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E4%BD%A3%E9%87%91%E6%8A%A5%E8%A1%A8/agent_center_commission_report_view.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E5%85%85%E5%80%BC%E8%AE%B0%E5%BD%95%F0%9F%91%8C/agent_center_recharge_record_view.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E6%88%91%E7%9A%84%E4%B8%9A%E7%BB%A9/agent_center_profit_record_view.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E6%8F%90%E6%88%90%E8%AE%B0%E5%BD%95/agent_center_commission_record_view.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E6%8F%90%E7%8E%B0%E8%AE%B0%E5%BD%95%F0%9F%91%8C/agent_center_withdraw_record_view.dart';
import 'package:flutter_tiyu_app/app/modules/agentCenter/views/finance/%E6%B8%B8%E6%88%8F%E8%AE%B0%E5%BD%95%F0%9F%91%8C/agent_center_game_record_view.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/redbag_rain_page.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/views/game_try_controller.dart';
import 'package:flutter_tiyu_app/app/modules/launch/display_ad_controller.dart';
import 'package:flutter_tiyu_app/app/modules/launch/display_ad_view.dart';
import 'package:flutter_tiyu_app/app/modules/launch/splash_controller.dart';
import 'package:flutter_tiyu_app/app/modules/launch/splash_view.dart';
import 'package:flutter_tiyu_app/app/modules/settings/views/settings_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/about_us_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/alternate_urls_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/app_lucky_wheel_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/bet_recording_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/feedback_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/find_balance_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/funding_details_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/inbox_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/personal_statements_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/question_feedback_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/system_notify_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/user_account_management_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/about_us_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/alternate_urls_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/app_lucky_wheel_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/bet_recording_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/change_avatar_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/customer_service_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/feedback_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/find_balance_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/funding_details_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/help_center_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/help_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/inbox_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/message_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/personal_statements_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/question_feedback_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/system_notify_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/user_account_management_view.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/user_info_view.dart';
import 'package:flutter_tiyu_app/app/modules/video/controllers/video_category_controller.dart';
import 'package:flutter_tiyu_app/app/modules/video/controllers/video_search_controller.dart';
import 'package:flutter_tiyu_app/app/modules/video/views/video_category_view.dart';
import 'package:flutter_tiyu_app/app/modules/video/views/video_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/video/views/video_search_view.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/dw_records_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/new_withdrawal_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/views/add_address_view.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/views/dw_records_view.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/views/new_withdrawal_view.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/views/recharge_detail_view.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/views/recharge_view.dart';
import 'package:flutter_tiyu_app/app/modules/webview/controllers/recharge_web_controller.dart';
import 'package:flutter_tiyu_app/app/modules/webview/controllers/web_page_controller.dart';
import 'package:flutter_tiyu_app/app/modules/webview/views/android_app_web_view.dart';
import 'package:flutter_tiyu_app/app/modules/webview/views/app_web_view.dart';
import 'package:flutter_tiyu_app/app/modules/webview/views/app_web_view_for_inappwebview.dart';
import 'package:flutter_tiyu_app/app/modules/webview/views/recharge_web_view.dart';
import 'package:flutter_tiyu_app/app/modules/webview/views/web_page_view.dart';
import 'package:flutter_tiyu_app/theme/setting/controller/controller.dart';
import 'package:flutter_tiyu_app/theme/setting/setting.dart';
import 'package:get/get.dart';

import '../modules/activity/controllers/controller_yuebao_page.dart';
import '../modules/activity/views/yuebao/yuebao_page_detail.dart';
import '../modules/activity/views/yuebao/yuebao_view.dart';
import '../modules/home/views/game_try_view.dart';
import '../modules/lottery/web/lottery_web_page.dart';
import '../modules/maintenance/controllers/maintenance_controller.dart';
import '../modules/maintenance/views/maintenance_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/tabs/bindings/tabs_binding.dart';
import '../modules/tabs/views/tabs_view.dart';
import '../modules/user/controllers/agent_center_web_controller.dart';
import '../modules/user/controllers/customer_service_controller.dart';
import '../modules/user/controllers/edit_password_controller.dart';
import '../modules/user/controllers/message_detail_controller.dart';
import '../modules/user/controllers/user_info_controller.dart';
import '../modules/user/views/agent_center_web_view.dart';
import '../modules/user/views/edit_password_view.dart';
import '../modules/user/views/new_user_account_management_view.dart';
import '../modules/video/controllers/video_black_detail_controller.dart';
import '../modules/video/controllers/video_detail_controller.dart';
import '../modules/video/views/video_black_detail_view.dart';
import '../modules/wallet/bindings/recharge_detail_binding.dart';

import '../modules/agentCenter/bindings/agent_center_binding.dart';
import '../modules/agentCenter/views/agent_center_view.dart';
import '../modules/agentCenter/bindings/agent_center_register_binding.dart';
import '../modules/agentCenter/views/create/agent_center_register_view.dart';
import '../modules/agentCenter/controllers/agent_center_game_record_controller.dart';
import '../modules/agentCenter/controllers/agent_center_recharge_record_controller.dart';
import '../modules/agentCenter/controllers/agent_center_withdraw_record_controller.dart';
import '../modules/agentCenter/controllers/agent_center_profit_record_controller.dart';
import '../modules/agentCenter/controllers/agent_center_member_report_controller.dart';
import '../modules/agentCenter/controllers/agent_center_commission_record_controller.dart';
import '../modules/agentCenter/controllers/agent_center_commission_report_controller.dart';
import '../modules/agentCenter/controllers/agent_center_transfer_sub_controller.dart';
import '../modules/agentCenter/views/member/agent_center_transfer_sub_view.dart';
import '../modules/agentCenter/controllers/agent_center_sub_member_detail_controller.dart';
import '../modules/agentCenter/views/member/agent_center_sub_member_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;
  // static const INITIAL = Routes.AGENT_CENTER;

  static final routes = [
    GetPage(
      name: _Paths.TABS,
      page: () => TabsView(),
      binding: TabsBinding(),
    ),
    GetPage(
      name: _Paths.WEB_VIEW,
      page: () => const AppWebView(),
    ),
    GetPage(
      name: _Paths.ANDROID_WEB_VIEW,
      page: () => const AndroidAppWebView(),
    ),
    GetPage(
      name: _Paths.WEB_VIEW_INAPP,
      page: () => const AppWebViewForInAppWebView(),
    ),
    GetPage(
      name: _Paths.RECHARGE_WEB_VIEW,
      page: () => const RechargeWebView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RechargeWebController());
      }),
    ),
    GetPage(
      name: _Paths.RECHARGE,
      page: () => const RechargeView(),
      // binding: RechargeBinding(),
    ),
    GetPage(
      name: _Paths.RECHARGE_USDT_DETAIL,
      page: () => const RechargeDetailView(),
      binding: RechargeDetailBinding(),
    ),
    GetPage(
      name: _Paths.NEW_RECHARGE_WITHDRAWAL,
      page: () => const NewWithdrawalView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => NewWithdrawalController());
      }),
    ),
    GetPage(
      name: _Paths.RECHARGE_ADD_ADDRESS,
      page: () => const AddAddressView(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_BLACK_DETAIL,
      page: () => const VideoBlackDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => VideoBlackDetailController());
      }),
    ),
    GetPage(
      name: _Paths.VIDEO_DETAIL,
      page: () => const VideoDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => VideoDetailController());
      }),
    ),
    GetPage(
      name: _Paths.ACCOUNT_MANAGEMENT,
      page: () => const UserAccountManagementView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => UserAccountManagementController());
      }),
    ),
    GetPage(
      name: _Paths.NEW_ACCOUNT_MANAGEMENT,
      page: () => const NewUserAccountManagementView(),
    ),
    // GetPage(
    //   name: _Paths.AGENT_CENTER,
    //   page: () => const AgentCenterView(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => AgentCenterController());
    //   }),
    // ),
    GetPage(
      name: _Paths.MESSAGE_NOTIFY,
      page: () => const QuestionFeedbackView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => QuestionFeedbackController());
      }),
    ),
    GetPage(
      name: _Paths.FEEDBACK_DETAIL,
      page: () => const FeedbackDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => FeedbackDetailController());
      }),
    ),

    // GetPage(
    //   name: _Paths.MESSAGE_NOTIFY,
    //   page: () => const MessageNotifyView(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => MessageNotifyController());
    //   }),
    // ),
    GetPage(
      name: _Paths.MESSAGE_DETAIL,
      page: () => const MessageDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MessageDetailController());
      }),
    ),
    GetPage(
      name: _Paths.USER_INFO,
      page: () => const UserInfoView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => UserInfoController());
      }),
    ),
    GetPage(
      name: _Paths.FUNDING_DETAILS,
      page: () => FundingDetailsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => FundingDetailsController());
      }),
    ),
    GetPage(
      name: _Paths.BET,
      page: () => const BetRecordingView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => BetRecordingController());
      }),
    ),
    GetPage(
      name: _Paths.ABOUT_US,
      page: () => const AboutUsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AboutUsController());
      }),
    ),
    GetPage(
      name: _Paths.ALTERNATE_URLS,
      page: () => const AlternateUrlsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AlternateUrlsController());
      }),
    ),
    GetPage(
      name: _Paths.HELP_CENTER,
      page: () => const HelpCenterView(),
    ),
    GetPage(
      name: _Paths.HELP_DETAIL,
      page: () => const HelpDetailView(),
    ),
    GetPage(
      name: _Paths.LUCKY_WHEEL,
      page: () => const AppLuckyWheelView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AppLuckyWheelController());
      }),
    ),
    GetPage(
      name: _Paths.CUSTOMER_SERVICE,
      page: () => const CustomerServiceView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CustomerServiceController());
      }),
    ),
    GetPage(
      name: _Paths.FIND_BALANCE,
      page: () => const FindBalanceView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => FindBalanceController());
      }),
    ),
    GetPage(
      name: _Paths.VIP,
      page: () => const VipView(),
    ),
    GetPage(
      name: _Paths.NEW_VIP_DETAIL,
      page: () => const VipDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => VipDetailController());
      }),
    ),
    GetPage(
      name: _Paths.INBOX_DETAIL,
      page: () => const InboxDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => InboxDetailController());
      }),
    ),
    // GetPage(
    //   name: _Paths.VIP_DETAIL,
    //   page: () => const VipDetailView(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => VipDetailController());
    //   }),
    // ),
    GetPage(
      name: _Paths.VIDEO_CATEGORY,
      page: () => const VideoCategoryView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => VideoCategoryController());
      }),
    ),
    GetPage(
      name: _Paths.VIDEO_SEARCH,
      page: () => const VideoSearchView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => VideoSearchController());
      }),
    ),
    GetPage(
      name: _Paths.LOTTERY_WEB_PATH,
      page: () => const LotteryWebPage(),
      // binding: BindingsBuilder(() {
      //   Get.lazyPut(() => VideoSearchController());
      // }),
    ),
    GetPage(
      name: _Paths.REBATE_RECORD,
      page: () => const RebateRecordView(),
    ),
    GetPage(
      name: _Paths.REBATE_DETAIL,
      page: () => const RebateRecordDetailView(),
    ),
    GetPage(
      name: _Paths.REBATE_PROPORTION,
      page: () => const RebateProportionView(),
    ),
    GetPage(
      name: _Paths.YUEBAO,
      page: () => const YuebaoView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ControllerYuebaoPage());
      }),
    ),
    GetPage(
      name: _Paths.YUEBAO_DETAIL,
      page: () => const YuebaoPageDetail(),
    ),
    GetPage(
      name: _Paths.WELCOME_BONUS,
      page: () => const WelcomeBonusView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WelcomeBonusController());
      }),
    ),
    GetPage(
      name: _Paths.LEADERBOARD_REWARD,
      page: () => const LeaderboardRewardView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LeaderboardRewardController());
      }),
    ),
    GetPage(
      name: _Paths.RELIEF_FUND,
      page: () => const ReliefFundView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ReliefFundController());
      }),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_WEB,
      page: () => const AgentCenterWebView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AgentCenterWebController());
      }),
    ),
    GetPage(
      name: _Paths.WEB_PAGE,
      page: () => const WebPageView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WebPageController());
      }),
    ),
    GetPage(
      name: _Paths.EDIT_PASSWORD,
      page: () => const EditPasswordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => EditPasswordController());
      }),
    ),
    GetPage(
      name: _Paths.CHANGE_AVATAR,
      page: () => const ChangeAvatarView(),
    ),
    GetPage(
      name: _Paths.MAINTENANCE,
      page: () => const MaintenanceView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MaintenanceController());
      }),
    ),
    GetPage(
      name: _Paths.SYSTEM_NOTIFY_DETAIL,
      page: () => const SystemNotifyDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SystemNotifyDetailController());
      }),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: _Paths.DISPLAY_AD,
      page: () => const DisplayAdView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DisplayAdController());
      }),
    ),
    GetPage(
      name: _Paths.PERSONAL_STATEMENTS,
      page: () => const PersonalStatementsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PersonalStatementsController());
      }),
    ),
    GetPage(
      name: _Paths.ACTIVITY_DETAIL,
      page: () => const ActivityDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ActivityDetailController());
      }),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER,
      page: () => const AgentCenterView(),
      binding: AgentCenterBinding(),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_REGISTER,
      page: () => const AgentCenterRegisterView(),
      binding: AgentCenterRegisterBinding(),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_GAME_RECORD,
      page: () => const AgentCenterGameRecordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AgentCenterGameRecordController());
        Get.lazyPut(() => NewHomeController());
      }),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_RECHARGE_RECORD,
      page: () => const AgentCenterRechargeRecordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AgentCenterRechargeRecordController());
      }),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_WITHDRAW_RECORD,
      page: () => const AgentCenterWithdrawRecordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AgentCenterWithdrawRecordController());
      }),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_PROFIT_RECORD,
      page: () => const AgentCenterProfitRecordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AgentCenterProfitRecordController());
      }),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_MEMBER_REPORT,
      page: () => const AgentCenterMemberReportView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AgentCenterMemberReportController());
      }),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_COMMISSION_RECORD,
      page: () => const AgentCenterCommissionRecordView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AgentCenterCommissionRecordController());
      }),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_COMMISSION_REPORT,
      page: () => const AgentCenterCommissionReportView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AgentCenterCommissionReportController());
      }),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_TRANSFER_SUB,
      page: () => const AgentCenterTransferSubView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AgentCenterTransferSubController());
      }),
    ),
    GetPage(
      name: _Paths.AGENT_CENTER_SUB_DETAIL,
      page: () => const AgentCenterSubMemberDetailView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AgentCenterSubMemberDetailController());
      }),
    ),
    GetPage(
      name: _Paths.GAME_TRY,
      page: () => const GameTryView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => GameTryController());
      }),
    ),
    GetPage(
      name: _Paths.REDBAG_DETAIL,
      page: () => RedbagRainView(),
      // binding: BindingsBuilder(() {
      //   Get.lazyPut(() => GameTryController());
      // }),
    ),
    GetPage(
      name: _Paths.ACTIVITY_TURNTABLE,
      page: () => ActivityTurntableDetail(),
    ),
    GetPage(
      name: _Paths.BOUNS_CENTER,
      page: () => const ActivityCollectionPage(),
    ),
    GetPage(
      name: _Paths.PROMOTION_DISCOUNT,
      page: () => const ActivityDiscountView(),
    ),
    GetPage(
      name: _Paths.DISCOUNT_RECORD,
      page: () => const ActivityDiscountRecordsView(),
    ),
    GetPage(
      name: _Paths.DW_RECORDS,
      page: () => const DwRecordsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DwRecordsController());
      }),
    ),
    GetPage(
      name: _Paths.MINE_SETTING,
      page: () => const SettingPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SettingController());
      }),
    ),
  ];
}
