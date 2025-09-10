import 'package:flutter_tiyu_app/app/data/tenant_bean.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';

import '../api/tenant_api.dart';
import '../app/data/app_customer_service_bean.dart';
import '../gen/assets.gen.dart';
import '../kernel/utils/app_utils.dart';
import 'package:collection/collection.dart';

//租户信息管理类
class TenantManager {
  TenantManager._privateConstructor();
  static final TenantManager instance = TenantManager._privateConstructor();
  TenantBean? _tenantBean; // 用在不需要监听的地方，不需要.value
  TenantBean? get tenantBean => _tenantBean;
  String appIconPath = ""; //app的icon地址
  RxString appImgDomainPath = "".obs; //app的图片域名
  bool isCanOpenCustomerService = false; //是否能打开在线客服列表页面，默认false
  Future<void> setTenantBean(TenantBean tenant) async {
    _tenantBean = tenant; // 先赋值
    isCanOpenCustomerService = checkIsCanOpenCS(); //检查是否能打开客服列表页面
    LogoManage? logoManage =
        tenant.logoManage?.firstWhereOrNull((value) => value.messageId == 29);
    if (logoManage != null) {
      appIconPath = logoManage.picAddr!; //得到图片地址，方便各个地方使用
    }
    // appImgDomainPath = await getCurrentImgDomain();
    getCurrentImgDomain().then((value) async {
      // await Future.delayed(Duration(seconds: 10));
      appImgDomainPath.value = value;
    });
  }

  RxInt errorImgCount = 0.obs;
  resetErrorImgCount() {
    errorImgCount.value = 0;
  }

  // 系统配置相关数据，其他地方有使用
  AseqBean? _aseqBean;
  AseqBean? get aseqBean => _aseqBean;
  void setAseqBean(AseqBean aseq) {
    _aseqBean = aseq;
  }

  // 所有彩票配置
  List<AllLotteryDataItemBean> _allLotteryData = [];
  List<AllLotteryDataItemBean> get allLotteryData => _allLotteryData;
  void setAllLotteryData(List<AllLotteryDataItemBean> data) {
    _allLotteryData = data;
  }

  // tab排序等
  List<VersionTypeItem> _versionType = [];
  List<VersionTypeItem> get versionType => _versionType;
  void setVersionType(List<VersionTypeItem> data) {
    _versionType = data;
  }

  //获取当前图片域名
  Future<String> getCurrentImgDomain() async {
    if (_tenantBean != null) {
      String imgUrl = await reqImgsUrl(_tenantBean!.imgsDomain);

      return imgUrl.endsWith('/')
          ? imgUrl.replaceAll(RegExp(r'/+$'), '')
          : imgUrl;
    }
    return "";
  }

  List<AppCustomerServiceBean> csData = [];
  //检查是否能够打开客服页面
  bool checkIsCanOpenCS() {
    if (_tenantBean == null || _tenantBean?.tenant == null) return false;

    Tenant tenant = _tenantBean!.tenant!;

    var tempList = [
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconQq,
          name: "QQ客服",
          contactAddress: tenant.qq),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconServicePhone,
          name: "客服电话",
          contactAddress: tenant.phone),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconWechat,
          name: "微信客服",
          contactAddress: tenant.weixin),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconQq,
          name: "QQ代理",
          contactAddress: tenant.qqAgent),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconWhatsapp,
          name: "Whatsapp",
          contactAddress: tenant.whatsApp),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconTelegram,
          name: "Telegram",
          contactAddress: tenant.telegram),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconFacebook,
          name: "Facebook",
          contactAddress: tenant.facebook),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconZalo,
          name: "Zalo",
          contactAddress: tenant.zalo),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconLine,
          name: "Line",
          contactAddress: tenant.line),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconYoutube,
          name: "Youtube",
          contactAddress: tenant.youtube),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconTwitter,
          name: "Twitter",
          contactAddress: tenant.twitter),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconInstagram,
          name: "Instagram",
          contactAddress: tenant.instagram),
      AppCustomerServiceBean(
          iconPath: Assets.theme1.images.user.service.iconTiktok,
          name: "Tiktok",
          contactAddress: tenant.tiktok),
    ];
    csData = tempList
        .where((item) =>
            (item.contactAddress != null && item.contactAddress!.isNotEmpty))
        .toList();

    return csData.isNotEmpty;
  }
}
