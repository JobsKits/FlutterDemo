import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import 'logic.dart';

class BlackListPage extends StatelessWidget {
  BlackListPage({super.key});

  final logic = Get.put(BlackListLogic());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 44,
              child: Row(
                children:  [
                  const SizedBox(width: AppValues.defaultPadding,),
                  Expanded(child: CustomText(S.current.back_list_action_text,textAlign: TextAlign.center,textColorStyle: CustomTextColorStyle.normal,)),
                  const SizedBox(width: AppValues.largePadding,),
                  Expanded(child: CustomText(S.current.back_list_player_text,textAlign: TextAlign.center,textColorStyle: CustomTextColorStyle.normal,)),
                  const SizedBox(width: AppValues.defaultPadding,),
                ],
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return BlackListCard(index: index,);
              },
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}

class BlackListCard extends StatelessWidget {
  final int index;
  const BlackListCard({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final isOdd = index % 2 == 1;
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: isOdd ? Colors.transparent : ThemeService().colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppValues.smallRadius)
      ),
      child: Row(
        children:  [
          
          const SizedBox(width: AppValues.defaultPadding,),
          Expanded(child: CustomText(S.current.random_text_461,textAlign: TextAlign.center,textColorStyle: CustomTextColorStyle.error,)),
          const SizedBox(width: AppValues.largePadding,),
          Expanded(child: CustomText('🌟 soxboppps',textAlign: TextAlign.center,textColorStyle: CustomTextColorStyle.normal,)),
          const SizedBox(width: AppValues.defaultPadding,),
        ],
      ),
    );
  }
  
}