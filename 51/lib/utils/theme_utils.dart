import '../theme/theme.service.dart';

class ThemeUtils {
  //拿到对应的底部导航栏动画文件路径
  static getBottomBarLottieIn(String title) {
    return "assets/lottie/${ThemeService.to.currentTheme.value?.model}/${title}_in.json";
  }

  static getBottomBarLottieOut(String title) {
    return "assets/lottie/${ThemeService.to.currentTheme.value?.model}/${title}_out.json";
  }
}
