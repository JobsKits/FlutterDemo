import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_icon.dart';

import '../../../services/theme/theme_service.dart';
import '../../../utils/function.dart';

// ignore: must_be_immutable
class SearchHistoryItem extends StatelessWidget {
  var name = '';
  late final GestureTapCallback? onTap;
  late final ParamSingleCallback<String> deleteWord;

  SearchHistoryItem({super.key, required this.name, required this.onTap,required this.deleteWord});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: ThemeService().theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        margin: EdgeInsets.symmetric(horizontal: 5,vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style:ThemeService().textTheme.labelMedium,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: 6,),
            InkWell(onTap:()=> deleteWord(name),child: CustomIcon(asset: 'assets/images/ic_closed.png',size: 10,))
          ],
        ),
      ),
    );
  }
}
