import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:get/get.dart';

import '../../../utils/function.dart';
import '../../../widget/custom_asset_icon.dart';

class FrontCasinoPageViewOne extends StatelessWidget {
  FrontCasinoPageViewOne({super.key, required this.images, this.callback});

  List<String> images;
  final ParamVoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 13, mainAxisSpacing: 13,childAspectRatio: 106/140),
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
                onTap: () { callback?.call();},
                child: CustomAssetIcon(
                  name: images[index],
                ));
          }),
    );
  }
}
