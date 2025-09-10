import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/input/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';

///搜索框，联盟计划-所有数据页面 用到
@Deprecated("使用 CustomAllianceSearchWidget")
class CustomAccountSearch extends StatefulWidget {
  const CustomAccountSearch({super.key});

  @override
  State<CustomAccountSearch> createState() => _CustomAccountSearchState();
}

class _CustomAccountSearchState extends State<CustomAccountSearch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2.0),
        // Add a border
        borderRadius: BorderRadius.circular(40), // Set border radius to 0
      ),
      // child: CupertinoSearchTextField(
      //   style: const TextStyle(
      //     color: AppThemes.textColorWhite, // Set text color to red
      //   ),
      //   backgroundColor: ThemeService().colorScheme.surface,
      //   borderRadius: BorderRadius.circular(40),
      //   placeholder: S.current.random_text_186,
      //     placeholderStyle: ThemeService().textTheme.labelLarge?.copyWith(color: ThemeService().colorScheme.onSurfaceVariant),
      //   // Use the prefixIcon property to customize the icon.
      //   // prefixIcon: const Padding(
      //   //   padding: EdgeInsets.only(top: 3),
      //   //   child: Icon(
      //   //     Icons.search, // You can use any custom icon you want here.
      //   //     color: CupertinoColors.systemGrey, // Customize the icon color.
      //   //   ),
      //   // ),
      //   prefixIcon:Container(),
      //   // suffixIcon: const Icon(
      //   //   Icons.search, // You can use any custom icon you want here.
      //   //   color: CupertinoColors.systemGrey, // Customize the icon color.
      //   // ),
      //   // suffixIcon: Image.asset("assets/images/alliance/ic_alliance_search_data.webp"),
      //   suffixIcon: ImageIcon("assets/images/alliance/ic_alliance_search_data.webp"),
      //   suffixMode: OverlayVisibilityMode.always,
      //   // suffixIcon:  const Icon(CupertinoIcons.xmark_circle_fill),
      //   // You can also customize the other properties as needed.
      //   onSubmitted: (value) {
      //     // Handle search when the user submits.
      //   },
      //   onSuffixTap: () {
      //     print("CustomAccountSearch...onSuffixTap...点击");
      //   },
      // ),
      child: CustomTextField(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        // const EdgeInsets.only(left: AppValues.defaultPadding),
        hintText: S.current.random_text_186,
        rightWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const CustomAssetIcon(
                name: "assets/images/alliance/ic_alliance_search_data.webp", size: 20)),
        // rightWidget: CustomA("assets/images/alliance/ic_alliance_search_data.webp"),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        inputCompletionCallBack: (value, isSubmitted) {
          log("inputCompletionCallBack...value:" + value.toString());
        },
        inputCallBack: (value) {
          log("inputCallBack...value:" + value.toString());
        },
      ),
    );
  }
}
