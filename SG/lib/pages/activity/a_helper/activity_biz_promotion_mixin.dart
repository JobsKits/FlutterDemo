import '../../../controllers/global_state_controller.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/lang_service.dart';

mixin ActivityBizPromotionMixin {
  ///是否支持，该货币，根据该coinBean 当前货币来判断， 返回值：null 表示不支持
  ///没有配置，切换币种，推广详情 不需要刷新，但需要提示语
  ///不支持的默认使用当前语言的，其他加密货币也使用usdt;
  /// 返回值 CurrencyBean， 是在本地语言货币范围之内
  CurrencyBean? isSupportCoinBean({
   required CurrencyBean coinBean,
    required List<String> langLabelList,
    required bool inputCoin,
  }) {
    String curCoinId = coinBean.cur ?? "";
    //是否在语言中的货币
    LangType? langTypeCoin = LangType.adaptorCoinId(coinBean.cur);
    //1、判断是否有配置
    // "CNY"), //中文
    // "USDT"), //英文
    // "BRL"), //葡萄牙
    // "VND"), //越南
    // "THB"), //泰语
    // "INR"); //印地语
    //本地语言 货币
    if (langTypeCoin != null) {
      //是否有配置
      bool isSupport = langLabelList.any((label) => label == langTypeCoin.label);
      if (isSupport) {
        return coinBean;
      } else {
        //走本地语言货币
        // var langCoinId = LangService().lang.coinId;
        // return localCoin ? GlobalStateController.of().adaptorLocalCoin(langCoinId) : null;
        // return GlobalStateController.of().adaptorLocalCoin(langCoinId) ?? coinBean;
        return inputCoin ? coinBean : null;
      }
    }
    //不是语言货币，其他的加密货币,默认使用usdt
    else {
      if (coinBean.isCryptoCoin()) {
        curCoinId = LangType.en.coinId;
      } else {
        curCoinId = LangService().lang.coinId;
      }
      CurrencyBean? coin = GlobalStateController.of().adaptorLocalCoin(curCoinId);
      return coin ?? coinBean;
    }
  }

  ///获取初始化 币种id，没有本地语言币种
  CurrencyBean getInitCoinBean(String? coinId) {
    CurrencyBean? coinBean = GlobalStateController.of().adaptorLocalCoin(coinId);
    //获取本地语言 coin
    var lang = LangService().lang;
    var langCoinBean =  CurrencyBean(cur: lang.coinId, name: lang.coinName);
    //支持货币检查
    CurrencyBean? checkCoinBean = isSupportCoinBean(
      coinBean: coinBean??langCoinBean,
      langLabelList: [],
      inputCoin: true,
    );
    return checkCoinBean?? langCoinBean;
  }

  ///获取初始化 币种id，没有本地语言币种
  CurrencyBean getNetApiCoinBean(String? coinId) {
    CurrencyBean? coinBean = GlobalStateController.of().adaptorLocalCoin(coinId);
    if (coinBean != null) {
      return coinBean;
    } else {
      //获取本地语言 coin
      var lang = LangService().lang;
      return CurrencyBean(cur: lang.coinId, name: lang.coinName);
    }
  }
}
