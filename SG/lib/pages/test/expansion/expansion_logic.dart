import 'package:flutter_bet/base/getx/base_controller.dart';

import '../../../widget/expansion/expand_item_model.dart';
import '../../../widget/expansion/expand_list_model.dart';

class ExpansionLogic extends BaseController {
  List<ExpandListModel> expandData = [
    ExpandListModel(
        showIcon: false,
        showRadio: true,
        value: 0,
        headTitle: "有单选框无icon",
        item: [
          ExpandItemModel(itemId: 0, itemTitle: '英雄联盟'),
          ExpandItemModel(itemId: 1, itemTitle: 'csgo'),
          ExpandItemModel(itemId: 2, itemTitle: '吃鸡'),
          ExpandItemModel(itemId: 3, itemTitle: 'csgo'),
          ExpandItemModel(itemId: 4, itemTitle: 'csgo'),
          ExpandItemModel(itemId: 5, itemTitle: 'csgo'),
          ExpandItemModel(itemId: 6, itemTitle: 'csgo'),
          ExpandItemModel(itemId: 7, itemTitle: 'csgo'),
          ExpandItemModel(itemId: 8, itemTitle: 'csgo'),
          ExpandItemModel(itemId: 9, itemTitle: 'csgo'),
        ]),
    ExpandListModel(showIcon: true, value: 2, headTitle: "无单选框有icon", item: [
      ExpandItemModel(itemId: 10, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 11, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 12, itemTitle: '红色警戒'),
      ExpandItemModel(itemId: 13, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 14, itemTitle: 'csgo'),
    ], showRadio: false),
    ExpandListModel(value: 3, headTitle: "无单选框无icon", item: [
      ExpandItemModel(itemId: 15, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 16, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 17, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 18, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 19, itemTitle: 'csgo'),
    ], showRadio: false),
    ExpandListModel(value: 4, headTitle: "所有电子项目", item: [
      ExpandItemModel(itemId: 20, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 21, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 22, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 23, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 24, itemTitle: 'csgo'),
    ], showRadio: false),
    ExpandListModel(value: 5, headTitle: "所有电子项目", item: [
      ExpandItemModel(itemId: 25, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 26, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 27, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 28, itemTitle: 'csgo'),
      ExpandItemModel(itemId: 29, itemTitle: 'csgo'),
    ], showRadio: false),
  ];
}
