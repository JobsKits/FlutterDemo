//首页游戏tab的假的实体类，暂时用于假数据展示
class HomeGameTabBean {
  HomeGameTabBean({
    required this.title,
    required this.iconPath,
    required this.pageKey,
    required this.key,
  });

  String title;
  String iconPath;
  String pageKey; //英文字段，用于排序跳转
  int key;

  @override
  String toString() {
    return 'HomeGameTabBean{title: $title, iconPath: $iconPath, pageKey: $pageKey, key: $key}';
  }
}

// 首页游戏详情tab
class HomeGameDetailTabBean {
  HomeGameDetailTabBean({
    required this.title,
    required this.iconPath,
    required this.activeIconPath,
    required this.colorIconPath, //带颜色的图标
    required this.playId,
    required this.width,
    required this.height,
  });

  String title;
  String iconPath;
  String colorIconPath;
  String activeIconPath;
  num playId;
  double width;
  double height;
}

// 首页游戏详情tab
class NewHomeGameDetailTabBean {
  NewHomeGameDetailTabBean({
    required this.title,
    required this.iconPath,
    required this.playId,
    required this.play_sort,
  });
  String title;
  String iconPath;
  num playId;
  num play_sort;

  @override
  String toString() {
    return 'NewHomeGameDetailTabBean{title: $title, iconPath: $iconPath, playId: $playId}';
  }
}
