//新首页游戏tab的实体类
class NewHomeGameTabBean {
  NewHomeGameTabBean({
    required this.title,
    required this.iconPath,
    required this.key,
    this.pageKey,
  });

  String title;
  String iconPath;
  String? pageKey;
  int key;

  @override
  String toString() {
    return 'NewHomeGameTabBean{title: $title, iconPath: $iconPath, key: $key}';
  }
}
