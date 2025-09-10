import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:get/get.dart';

import '../../../base/getx/page_state.dart';
import '../../../services/lang_service.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';

class PromotionStudyLogic extends GetxController {
  final loadState = PageState.SUCCESS.obs;
  final studyPicAssetObs = "".obs;

  final refreshCtrl = CustomRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

  @override
  void onInit() {
    super.onInit();
    initStudyPic();
  }

  void initStudyPic() {
    var lang = LangService().lang;
    switch (lang) {
      case LangType.zhCN:
        studyPicAssetObs.value = "assets/images/alliance/study/alliance_study_cn.webp";
        break;
      case LangType.en:
        studyPicAssetObs.value = "assets/images/alliance/study/alliance_study_en.webp";
        break;
      case LangType.pt:
        studyPicAssetObs.value = "assets/images/alliance/study/alliance_study_pt.webp";
        break;
      case LangType.vi:
        studyPicAssetObs.value = "assets/images/alliance/study/alliance_study_vi.webp";
        break;
      case LangType.th:
        studyPicAssetObs.value = "assets/images/alliance/study/alliance_study_th.webp";
        break;
      case LangType.hi:
        studyPicAssetObs.value = "assets/images/alliance/study/alliance_study_hi.webp";
        break;

      default:
        studyPicAssetObs.value = "assets/images/alliance/study/alliance_study_en.webp";
        break;
    }
  }
}
