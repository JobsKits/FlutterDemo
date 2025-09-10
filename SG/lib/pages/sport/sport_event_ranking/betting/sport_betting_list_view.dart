import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constant/app_values.dart';
import '../../../../../services/theme/theme_service.dart';
import '../../../../../widget/custom_text.dart';
import 'sport_betting_item_view.dart';
import 'sport_betting_list_logic.dart';

///体育赛事 内嵌的排行榜，所有投注、风云榜  公用 list
class SportBettingListPage extends StatefulWidget {
  SportBettingListPage({Key? key}) : super(key: key);

  @override
  State<SportBettingListPage> createState() => _SportBettingListPageState();
}

class _SportBettingListPageState extends State<SportBettingListPage> {
  final logic = Get.put(SportBettingListLogic());

  @override
  void dispose() {
    Get.delete<SportBettingListLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Column(
    //     children: [
    //       Container(height: 200,color: Colors.red),
    //       Container(height: 300,color: Colors.green),
    //       Container(height: 400,color: Colors.blue),
    //     ],
    //   ),
    // );
    return  _buildListView();
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
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
          return SportBettingItemView(index: index, model: logic.modelList[index]);
        },
      );
    });
  }

  _buildListTitle() {
    return Container(
      height: 54,
      padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            S.current.random_text_286,
            style: ThemeService().textTheme.labelLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
          ),
          CustomText(
            S.current.random_text_227,
            style: ThemeService().textTheme.labelLarge?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
