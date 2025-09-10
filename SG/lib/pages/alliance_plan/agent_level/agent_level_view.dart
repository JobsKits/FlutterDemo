import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_view.dart';
import '../../../constant/app_values.dart';
import '../../../routes/routes.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/custom_text.dart';
import 'agent_level_logic.dart';
import 'agent_level_view_item.dart';

///联盟计划-点击头像-代理等级
class AgentLevelPage extends BaseView<AgentLevelLogic> {
  AgentLevelPage({Key? key}) : super(key: key);

  final logic = Get.find<AgentLevelLogic>();
  final state = Get.find<AgentLevelLogic>().state;

  ///打开页面
  static openPage() {
    RouteUtil.pushToView(Routes.personalAgentLevel);
  }


  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleView: Text(S.current.random_text_47),
      showLeading: true,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.defaultPadding,
        // vertical: AppValues.defaultPadding,
      ),
      child: Column(
        children: [
          _buildListTitle(),
          _buildListView(),
          SizedBox(height: AppValues.margin_40),
        ],
      ),
    );
  }

  _buildListTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.defaultPadding,
        // vertical: AppValues.defaultPadding,
      ),
      height: 54,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            S.current.random_text_47,
            style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          CustomText(
            S.current.random_text_48,
            style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  _buildListView() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: logic.modelList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return AgentLevelItemView(index: index, model: logic.modelList[index]);
          },
        );
      }),
    );
  }
}
