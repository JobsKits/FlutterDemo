import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/pages/home/home_logic.dart';
import 'package:flutter_bet/services/event/event_service.dart';
import 'package:get/get.dart';

class MatchDetailLogic extends BaseController {
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> onArticleCollect() async {
    EventService.instance.dispatchEvent(kDidArticleCollectEvent,S.current.random_text_351);
  }

}
