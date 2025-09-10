
///标记 页面时来时哪里的
enum SportMyBetFromPage{
  ///来自体育首页
  fromSportHome(type: 1),
  fromSportOther(type: 10);
  final int type;
  const SportMyBetFromPage({required this.type});
}