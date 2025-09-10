import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constant/app_values.dart';
import '../../../../../services/theme/theme_service.dart';
import '../../../../../widget/custom_asset_icon.dart';
import '../../../../../widget/custom_text.dart';
import 'sport_compete_item_view.dart';
import 'sport_compete_list_logic.dart';

///体育赛事 内嵌的排行榜，竞赛排行榜 list
class SportCompeteListPage extends StatefulWidget {
  SportCompeteListPage({Key? key}) : super(key: key);

  @override
  State<SportCompeteListPage> createState() => _SportCompeteListPageState();
}

class _SportCompeteListPageState extends State<SportCompeteListPage> {
  final logic = Get.put(SportCompeteListLogic());

  @override
  void dispose() {
    Get.delete<SportCompeteListLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Text("竞赛排行榜"),
    // );
    return _buildListView();
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildTimeView(),
        _buildListTitle(),
        // Expanded(child: _buildListView()),
        _buildListView(),
      ],
    );
  }

  _buildListView() {
    return Obx(() {
      return ListView.builder(
        // physics: BouncingScrollPhysics(),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: logic.modelList.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return SportCompeteItemView(index: index, model: logic.modelList[index]);
        },
      );
    });
  }

  _buildListTitle() {
    return Container(
      height: 54,
      padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: CustomText(S.current.random_text_282,
                  textAlign: TextAlign.center,
                  style: ThemeService().textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ))),
          Expanded(
              flex: 2,
              child: CustomText(S.current.back_list_player_text,
                  textAlign: TextAlign.center,
                  style: ThemeService().textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ))),
          Expanded(
              flex: 3,
              child: CustomText(S.current.statistics_title_total_text,
                  textAlign: TextAlign.center,
                  style: ThemeService().textTheme.labelLarge?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ))),
          Expanded(
            child: CustomText(S.current.transactions_other_bonus,
                textAlign: TextAlign.center,
                style: ThemeService().textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    )),
          )
        ],
      ),
    );
  }

  _buildTimeView(){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Row(
       children: [
         CustomAssetIcon(size: 14, name: "assets/images/sport/ic_sport_betting_double.webp"),
         SizedBox(width: 4),
         CustomText('\$'+S.current.random_text_496,
             textAlign: TextAlign.center,
             style: ThemeService().textTheme.bodyMedium?.copyWith(
               fontSize: 14,
               fontWeight: FontWeight.w600,
             )),
         Spacer(),
         CustomAssetIcon(size: 14, name: "assets/images/sport/ic_sport_betting_double.webp"),
         SizedBox(width: 4),
         CustomText(S.current.random_text_281,
             textAlign: TextAlign.center,
             style: ThemeService().textTheme.bodyMedium?.copyWith(
               fontSize: 14,
               fontWeight: FontWeight.w600,
             )),
       ],
      ),
    );
  }
}
