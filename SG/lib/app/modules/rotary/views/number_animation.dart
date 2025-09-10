import '../../../../constant/app_themes.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

///数字动效
class NumberAnimation extends StatelessWidget {
  final double startNumber;
  final double targetNumber;
  final Duration? duration;

  const NumberAnimation({
    super.key,
    required this.startNumber,
    required this.targetNumber,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: startNumber, end: targetNumber), // 使用起始数字
      duration: duration??const Duration(seconds: 1),
      builder: (
          BuildContext context,
          double value,
          Widget? child) {
        // Customize how the number is displayed with decimal format
        String formattedValue = value.toStringAsFixed(2); // 将小数格式化为两位小数
        return CustomText(
            targetNumber == 0 ? targetNumber.toStringAsFixed(2) : formattedValue,
          style: const TextStyle(
              color: AppThemes.widgetColorWhite,
              fontSize: 32),
        );
      },
    );

    // String formattedValue = targetNumber.toStringAsFixed(2); // 将小数格式化为两位小数
    // return CustomText(
    //   formattedValue,
    //   style: const TextStyle(color: AppThemes.widgetColorWhite, fontSize: 32),
    // );
  }
}