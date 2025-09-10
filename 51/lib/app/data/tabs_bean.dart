//tab的假数据实体类
class TabsBean {
  TabsBean({required this.title, required this.inPath, required this.outPath});
  final String title;
  String inPath;
  String outPath;

  @override
  String toString() {
    return 'TabsBean{title: $title, inPath: $inPath, outPath: $outPath}';
  }
}
