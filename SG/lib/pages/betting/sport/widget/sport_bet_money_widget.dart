import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_text.dart';
import '../../common_model/betting_money_api_model.dart';

///体育 投注金额组件
class SportBetMoneyListViewWidget extends StatefulWidget {
  const SportBetMoneyListViewWidget({
    super.key,
    required this.modelList,
    this.onClickItem,
    this.isCanClick = true,
    this.isReset = false,
    this.selectedIndex,
  });

  final List<BettingMoneyApiModel> modelList;
  final bool isCanClick; //是否可以点击
  final bool isReset; //是否重置 选中
  final int? selectedIndex; //指定选中的

  //再次点击取消选中, 返回null
  final void Function(int? index, BettingMoneyApiModel? model)? onClickItem;

  @override
  State<SportBetMoneyListViewWidget> createState() => _SportBetMoneyListViewWidgetState();
}

class _SportBetMoneyListViewWidgetState extends State<SportBetMoneyListViewWidget> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedIndex = widget.selectedIndex;
    return Container(
      height: 40.h,
      margin: const EdgeInsets.only(bottom: 12),
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        itemCount: widget.modelList.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (!widget.isCanClick) {
                return;
              }
              //再次点击取消选中
              if (_selectedIndex == index) {
                _selectedIndex = null;
              } else {
                _selectedIndex = index;
              }
              if (widget.onClickItem != null) {
                widget.onClickItem!
                    .call(_selectedIndex, _selectedIndex != null ? widget.modelList[index] : null);
              }
              setState(() {});
            },
            child: Container(
              // height: 40,
              width: 78.w,
              margin: const EdgeInsets.only(right: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color:
                        _selectedIndex == index ? const Color(0xFF1475E1) : const Color(0xFF304554),
                    width: 2.w),
                // color: const Color(0xFF304554) ,
                color: _selectedIndex == index ? const Color(0xFF213743) : const Color(0xFF304554),
              ),
              child: CustomText(
                "${widget.modelList[index].betMoney}",
                style: ThemeService()
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    );
  }
}
