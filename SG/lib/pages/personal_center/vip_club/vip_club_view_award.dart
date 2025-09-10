
import 'package:flutter/widgets.dart';

import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import 'vip_club_logic.dart';

/// vip俱乐部-里面的奖励列表 item ，每一行
class VipClubAwardView extends StatelessWidget{
  const VipClubAwardView({super.key,required this.modelList});

  final List<VipAwardModel> modelList;
  @override
  Widget build(BuildContext context){
    return Container(
      child: Row(
        children: modelList.map((model) => _buildCell(model)).toList(),
      ),
    );
  }

  Widget _buildCell(VipAwardModel model){
    return Expanded(
      flex: model.isTitle? 2:1,
      child: Container(
        // width: model.isTitle? 100:60,
        height: 60,
        color: ThemeService().colorScheme.surface,
        margin: EdgeInsets.all(2),
        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
        alignment: Alignment.center,
        child: CustomText(
          model.detail,
          textAlign: TextAlign.center,
          style: ThemeService()
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }

}