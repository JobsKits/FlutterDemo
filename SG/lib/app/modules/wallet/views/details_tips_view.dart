import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

class DetailsTipsView extends GetView {
  final String tips;

  DetailsTipsView(this.tips);

  @override
  Widget build(BuildContext context) {
    return _tips();
  }

  Widget _tips() {
    return Container(
      margin: const EdgeInsets.only(top: AppValues.padding_16),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/pay_method/pay_details_tips_bg.png'),
              fit: BoxFit.fill)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3, right: 6, left: 4),
                child: Image.asset('assets/images/personal_center_icon/wallet/cards_warning.png',
                    width: 16),
              ),
              Flexible(
                // 使用 Flexible 包裹 Column
                child: CustomText(
                  "${tips}",
                  textColorStyle: CustomTextColorStyle.secondary,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  softWrap: true,
                ),
              ),
              const SizedBox(width: 2),
            ],
          ),
        ),
      ),
    );
  }
}
