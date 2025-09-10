import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_ok_button_widget.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
// import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:get/get.dart';

import '../controllers/add_address_controller.dart';
import '../widget/add_address_select_pop_widget.dart';
import '../widget/wallet_input_field_widget.dart';

//添加提现地址的界面
class AddAddressView extends StatefulWidget {
  const AddAddressView({
    super.key,
  });

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  late AddAddressController controller = Get.put(AddAddressController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          controller.title,
          style: TextStyle(
              fontSize: 57.sp, color: context.customTheme?.titleColor),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  //构建主体
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 40.h, left: 30.w, right: 30.w),
        child: Column(
          children: [
            // Obx(
            //   () => AddAddressSelectPopWidget(
            //     label: '数字钱包',
            //     popSelectList: controller.popSelectList,
            //     currentPopSelect: controller.currentPopSelect.value,
            //     onTap: (data) => controller.updateCurrentPopSelect(data),
            //   ),
            // ),
            ..._buildSelectPopListWidget(),
            _buildCommonWidget(),
          ],
        ),
      ),
    );
  }

  // 构建需要下拉选择的项目
  List<Widget> _buildSelectPopListWidget() {
    print("当前type:${controller.currentType}");
    List<Widget> resultData = [];
    // 银行卡
    if (controller.currentType == 2) {
      resultData.add(
        Obx(
          () => AddAddressSelectPopWidget(
            label: '数字钱包',
            popSelectList: controller.popSelectList,
            currentPopSelect: controller.currentPopSelect.value,
            onTap: (data) => controller.updateCurrentPopSelect(data),
          ),
        ),
      );
    }
    // 银行卡
    if (controller.currentType == 3) {
      resultData.add(
        Obx(
          () => controller.popSelectList.isNotEmpty
              ? AddAddressSelectPopWidget(
                  label: '开户行',
                  popSelectList: controller.popSelectList,
                  currentPopSelect: controller.currentPopSelect.value,
                  onTap: (data) => controller.updateCurrentPopSelect(data),
                  isShowSearch: true,
                )
              : SizedBox(),
        ),
      );
    }

    // 虚拟币
    if (controller.currentType == 1) {
      resultData.add(
        Obx(
          () => AddAddressSelectPopWidget(
            label: '虚拟币类型',
            popSelectList: controller.popSelectList,
            currentPopSelect: controller.currentPopSelect.value,
            onTap: (data) => controller.updateCurrentPopSelect(data),
          ),
        ),
      );

      resultData.add(
        Obx(
          () => AddAddressSelectPopWidget(
            label: '交易协议',
            popSelectList: controller.virtualPopSelectList,
            currentPopSelect: controller.virtualCurrentPopSelect.value,
            onTap: (data) => controller.updateVirtualCurrentPopSelect(data),
          ),
        ),
      );
    }

    return resultData;
  }

  // 构建公用内容区域
  Widget _buildCommonWidget() {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.only(top: 60.h, left: 40.w, right: 40.w, bottom: 105.h),
      decoration: BoxDecoration(
          color: context.customTheme?.pageTwoBg,
          borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildInputList(),
          SizedBox(
            height: 43.h,
          ),
          RechargeOkButtonWidget(
            text: "确定绑定",
            clickButton: () {
              AppManager.instance.tapVibrate();
              DebounceThrottle.debounce(controller.handleBindCard)();
            },
          ),
        ],
      ),
    );
  }

  //构建不同类型的输入列表
  List<Widget> _buildInputList() {
    List<Widget> resultList = [];

    /// 虚拟币
    if (controller.currentType == 1) {
      resultList.add(WalletInputFieldWidget(
        title: '虚拟币地址',
        placeholder: '请输入您的虚拟币地址',
        displayType: DisplayType.paste,
        onChanged: (value) => controller.setPayNo(value),
      ));

      /// 银行卡
    } else if (controller.currentType == 3) {
      resultList.add(WalletInputFieldWidget(
        title: '银行卡号',
        placeholder: '请输入您的银行卡卡号',
        displayType: DisplayType.paste,
        onChanged: (value) => controller.setPayNo(value),
      ));

      if (controller.boundName == null) {
        resultList.add(WalletInputFieldWidget(
          title: '持卡人姓名',
          placeholder: '请输入您的真实姓名',
          displayType: DisplayType.paste,
          onChanged: (value) => controller.setPayName(value),
        ));
      } else {
        resultList.add(WalletInputFieldWidget(
          title: '持卡人姓名',
          readOnly: true,
          placeholder: controller.boundName!,
          displayType: DisplayType.none,
        ));
      }

      /// 支付宝
    } else if (controller.currentType == 4) {
      resultList.add(WalletInputFieldWidget(
        title: '支付宝账号',
        placeholder: '请输入您的支付宝账号',
        displayType: DisplayType.paste,
        onChanged: (value) => controller.setPayNo(value),
      ));

      resultList.add(WalletInputFieldWidget(
        title: '姓名',
        placeholder: '请输入您的真实姓名',
        displayType: DisplayType.paste,
        onChanged: (value) => controller.setPayName(value),
      ));

      /// 其他类型
    } else {
      resultList.add(WalletInputFieldWidget(
        title: '钱包地址',
        placeholder: '请输入您的数字钱包地址',
        displayType: DisplayType.paste,
        onChanged: (value) => controller.setPayNo(value),
      ));

      if (controller.boundName == null) {
        resultList.add(WalletInputFieldWidget(
          title: '姓名',
          placeholder: '请输入您的真实姓名',
          displayType: DisplayType.paste,
          onChanged: (value) => controller.setPayName(value),
        ));
      } else {
        resultList.add(WalletInputFieldWidget(
          title: '姓名',
          readOnly: true,
          placeholder: controller.boundName!,
          displayType: DisplayType.none,
        ));
      }
    }

    // 支付密码
    resultList.add(WalletInputFieldWidget(
      isPwdNewStyle: true,
      obscureText: true,
      title: '支付密码',
      placeholder: '请输入您的支付密码',
      displayType: DisplayType.password,
      onChanged: (value) => controller.setAcctPwd(value),
    ));

    return resultList;
  }
}
