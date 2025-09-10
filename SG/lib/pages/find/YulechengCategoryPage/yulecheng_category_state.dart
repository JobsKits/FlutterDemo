import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../model/yulecheng/gamelist_model.dart';

class YulechengCategoryState {
  late RxList<GameListModel> dataArray = <GameListModel>[].obs;
  List<Map> sortType = [
    {"assets": "", "name": "A-Z"},
    {"assets": "", "name": "Z-A"},
    {"assets": "", "name": S.current.sport_event_list_sort_hot},
    {"assets": "", "name": S.current.random_text_265},
  ];
  int currentSortType = 2;
  bool isLoading = true;

  ///显示底部加载更多
  bool showLoadMore = false;

  /// 显示排序方式
  bool showSorttype = true;

  bool showQieHuanPage = false;

  int totalGame = 0;

  late RxList<Sum> changguanSumArray = <Sum>[].obs;

  late RxList<GameLobbyModel> ty1DataArray = <GameLobbyModel>[].obs;

  ///搜索详情页展示内容 0：提示至少3个字符+搜索记录 1:搜索无结果+搜索记录 2:展示搜索结果（搜索记录与搜索结果与{selectedType}相关）
  late RxInt showSearchType;

  ///输入框已输入文本
  late RxString searchContent;

  ///输入框文本控制器
  late TextEditingController textController;

  late RxBool isFocused; // 用于保存焦点状态
  ///搜索历史记录，从SP中取出动态生成
  late RxList<String> history;

  ///搜索娱乐城游戏结果
  late RxList<GameListModel> searchCasinoList;

  ///当前选择的体育还是娱乐城 0: 娱乐城 1: 体育
  late RxInt selectedType;

  ///当前展示内容 0: 导航 1: 搜索详情页
  late RxInt showInfoType;
}
