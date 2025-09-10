import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';

import '../../../constant/app_values.dart';
import '../../../services/lang_service.dart';
import '../../../widget/custom_text.dart';
import '../common_model/betting_common_params.dart';

///娱乐城列表title。 我的投注、所有投注、风云榜
class BettingCasinoListTitleView extends StatelessWidget {
  const BettingCasinoListTitleView({super.key, this.fromPageType});

  ///todo:0129.为了适配国际化语言， 浏览菜- 体育- 我的构投注
  ///中文所有投注 和 风云榜的标题不同， 但是正对越南文，会不同。从上面的路径过来需要更改。我的投注在（ 体育）中 ： （Thanh toán） 需要改成（Số Tiền Cược）
  final BettingFromPageType? fromPageType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Row(
        children: [
          CustomText(
            S.current.home_game,
            style: ThemeService().textTheme.labelLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Spacer(),
          CustomText(
            adapterViLanguage() ? S.current.random_text_227 : S.current.random_text_220copy,
            style: ThemeService().textTheme.labelLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  ///适配越南语言
  /// 中文所有投注 和 风云榜的标题不同， 但是正对越南文，会不同。
  /// 从上面的路径过来需要更改。我的投注在（ 体育）中 ： （Thanh toán） 需要改成（Số Tiền Cược）
  bool adapterViLanguage() {
    return fromPageType != null &&
        BettingFromPageType.isFromBrowseMenuSport(fromPageType) &&
        LangService().lang == LangType.vi;
  }
}
