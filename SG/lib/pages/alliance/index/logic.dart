import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';

class AllianceLogic extends BaseController {
  int selectedIndex = 0;
  String selectedString = S.current.alliance_summary;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  void selectedChanged(index) {
    // selectedIndex = index;
    selectedString = index;
    update(['alliance_page']);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
