import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_view.dart';
import '../../../widget/sport/custom_sport_odd_type.dart';
import '../../../widget/sport/custom_sport_section.dart';
import 'logic.dart';

class SportFavoriteWidget extends BaseView<SportFavoriteLogic> {
  SportFavoriteWidget({Key? key}) : super(key: key);

  final logic = Get.put(SportFavoriteLogic());
  final state = Get.find<SportFavoriteLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [1, 1, 1, 1, 1]
            .asMap()
            .entries
            .map((e) => CustomSportSection(SportListCategotyType.sport_other, (type, section, row, colum, int si,String eid) {},0, e.key,'','',''))
            .toList());
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    throw UnimplementedError();
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    throw UnimplementedError();
  }
}
