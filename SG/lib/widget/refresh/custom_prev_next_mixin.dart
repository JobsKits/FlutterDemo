import 'package:get/get.dart';

import '../../model/page_common_model.dart';

///适配几把 上下页
///上一页 下一页  核心逻辑 参数
///如何使用呢？ 一个在logic  中 with 该mixin
mixin CustomPrevNextMixin {
  final hasPrevPageObs = false.obs; //是否还有上一页
  final hasNextPageObs = false.obs; //是否还有下一页

  //对外 提供 get , 省略 .value
  bool get hasPrevPage => hasPrevPageObs.value;

  bool get hasNextPage => hasNextPageObs.value;

  int _pnCurPageIndex = 1;
  int _pnTotalPage = 1;

  ///是否显示 上下页 组件， 业务需是 只有一页时 不显示
  final _showPnPageWidgetObs = false.obs;

  bool get pnWidgetShow => _showPnPageWidgetObs.value;

  void set pnWidgetShow(bool show) => _showPnPageWidgetObs.value = show;

  int get pnCurPage => _pnCurPageIndex;

  int get pnTotalPage => _pnTotalPage;

  ///获取prev 和 next 情况下的请求索引
  ///对pageModel 进行二次封装， 为了以后提供适配入口
  int getPnRequestIndex(PageCommonModel pageModel, {bool prevPage = true, int? jumpPage}) {
    return pageModel.getPnPageIndex(prevPage, jumpPage: jumpPage);
  }

  ///更新上一页 和 下一页 当前索引 和 显示状态
  void refreshPnPage(PageCommonModel pageModel, PageCommonModel apiModel,
      {bool prevPage = true, int? jumpPage}) {
    pageModel.updatePnCurPage(prevPage, jumpPage: jumpPage);
    // betCasinoMyBetListObs.value = apiModel.content;
    pageModel.copyWithPnData(apiModel);
    // pageModel.content =apiModel.content;
    //空数据情况：{"status":true,"data":{"d":null,"t":0,"s":0}}
    //当前页
    _pnCurPageIndex = pageModel.getPnCurPage();
    //总页数，向上取整
    if (apiModel.resultPageSize != 0) {
      _pnTotalPage = (apiModel.total / apiModel.resultPageNeedSize).ceil();
      //如果总总页数为1 不显示
      pnWidgetShow = _pnTotalPage > 1;
    }
    updatePnStatus(apiModel);
  }

  ///跟新 prev 和 next 的显示状态
  void updatePnStatus(PageCommonModel apiModel) {
    // hasPrevPageObs.value = apiModel.hasPrevPage();
    // hasNextPageObs.value = apiModel.hasNextPage2();

    hasPrevPageObs.value = _pnCurPageIndex > 1 && _pnCurPageIndex <= _pnTotalPage;
    hasNextPageObs.value = _pnCurPageIndex < _pnTotalPage;
  }
}
