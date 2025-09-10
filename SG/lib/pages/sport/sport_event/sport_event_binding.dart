import 'package:get/get.dart';

import 'sport_event_logic.dart';


class SportEventBinding extends Bindings {
  SportEventBinding({this.pageTag});
  final String? pageTag;
  @override
  void dependencies() {
    Get.lazyPut(() => SportEventLogic(),tag: pageTag);
    // Get.create<SportEventLogic>(() => SportEventLogic(),permanent: false);
  }
}
