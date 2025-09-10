
import '../refresh/widget/cupertino/easy_refresh_path.dart';

mixin CustomToolTipMixin {
  final GlobalKey _globalKeyCopy = GlobalKey();
  final GlobalKey _globalKeyTip = GlobalKey();


  //偏移计算
  double?  onOffsetCallback(Size size , Offset offset, GlobalKey iconKey){
    // 获取组件 icon大小和偏移
    final RenderBox iconRenderBox = iconKey.currentContext?.findRenderObject() as RenderBox;
    Size iconSize = iconRenderBox.size;
    final iconOffset = iconRenderBox.localToGlobal(Offset.zero);
    // log("offsetCallback...iconSize=$iconSize...iconOffset=$iconOffset");
    // 获取组件 tooltip大小和偏移
    final RenderBox tipRenderBox =
    _globalKeyTip.currentContext?.findRenderObject() as RenderBox;

    Size tipSize = tipRenderBox.size;
    final tipOffset = tipRenderBox.localToGlobal(Offset.zero);
    // log("offsetCallback...tipSize=$tipSize...tipOffset=$tipOffset");
    return iconOffset.dx - tipOffset.dx + iconSize.width / 2;
  }

}