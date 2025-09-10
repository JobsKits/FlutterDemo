import 'package:flutter/material.dart';

class LotteryOddevenItem extends StatefulWidget {
  // final PlayGroup? data;
  // final GamePlayOddsModel? details;
  // final Function(List<Play>, List<PlayGroup>)? onChange;
  // const ConnectCodePlayItem(
  //     {super.key, this.data, this.details, this.onChange});
  @override
  State<LotteryOddevenItem> createState() => _LotteryOddevenItemState();
}

class _LotteryOddevenItemState extends State<LotteryOddevenItem> {
  // List<PlayGroup> selectGroupList = [];

  // late final list = List.generate(
  //     50 * (widget.data?.plays?.length ?? 1),
  //     (index) => ArrObj(
  //         value: "${index % 50}", key: "$index", id: UuidUtil.to.v4())); // 列表

  // List<ArrObj> selectList = [];

  // handleSelect(ArrObj value) {
  //   final isHave = selectList.firstWhereOrNull((e) => e.id == value.id);
  //   if (isHave != null) {
  //     selectList.remove(value);
  //   } else {
  //     selectList.add(value);
  //   }
  //   setState(() {});
  //   handleChange();
  // }

  // handleChange() {
  //   List<Play> plays = [];
  //   List<PlayGroup> groups = [];
  //   final result = LotteryConfig.threeBthGenRandom(
  //       selectList.map((e) => int.tryParse(e.value ?? '0') ?? 0).toList());
  //   LogUtil.w("result____$result");
  //   // widget.onChange?.call(plays, selectGroupList);
  //   if (selectList.length < 3) {
  //     widget.onChange?.call([], []);
  //     return;
  //   }
  //   for (var e in selectList) {
  //     final play =
  //         widget.data!.plays![(int.tryParse(e.value ?? "0") ?? 0) ~/ 50];
  //     plays.add(play);
  //   }

  //   groups.add(widget.data!.copyWith(plays: [
  //     widget.data!.plays!.first.copyWith(
  //       name: selectList.map((e) => e.value).join(","),
  //       alias: selectList.map((e) => e.value).join(","),
  //     )
  //   ]));
  //   widget.onChange?.call(plays, groups);
  // }

  // init() {
  //   debounce(GlobalService.to.robotRandom, (value) {
  //     if (!mounted) {
  //       return;
  //     }

  //     /// 随机group，在随机plays
  //     // final result = LotteryConfig.robotRandomSelect([widget.data ?? const PlayGroup()], 1);
  //     selectGroupList = [];
  //     final result = EventUtils.robotRandom(list.length);
  //     // final
  //     selectList = [];
  //     selectList.addAll(result.map((e) => list[e]).toList());
  //     LogUtil.w(widget.data?.plays);
  //     final plays = [].cast<Play>();
  //     for (var e in result) {
  //       plays.add(widget.data!.plays![e ~/ 50]);
  //       selectGroupList
  //           .add(widget.data!.copyWith(plays: [widget.data!.plays![e ~/ 50]]));
  //     }
  //     LogUtil.w(plays);
  //     handleChange();
  //     // final plays = widget.data?.plays
  //     // selectList = result.currentPlay ?? [];
  //     //   plays: selectList
  //     // ) ??const PlayGroup()]);
  //     setState(() {});
  //     // selectList.addAll(result.currentPlay);

  //     // selectGroupList =
  //   }, time: 0.milliseconds);

  //   debounce(GlobalService.to.deleteGroup, (value) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {
  //       selectList.clear();
  //     });
  //   }, time: 0.milliseconds);
  // }

  @override
  void initState() {
    // init();
    super.initState();
  }

  // String _buildOddds() {
  //   String result = "";
  //   widget.data?.plays?.forEach((e) {
  //     result += "${double.tryParse(e.odds ?? "0")}/";
  //   });
  //   return result.endsWith("/")
  //       ? result.substring(0, result.length - 1)
  //       : result;
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2, // 每行2个元素
        crossAxisSpacing: 10.0, // 列间距
        mainAxisSpacing: 10.0, // 行间距
        childAspectRatio: 2.0, // 控制子元素的宽高比
        children: List.generate(6, (index) {
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: Text(
                'Text $index',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }),
      ),
    );

    // ListView.builder(
    //   itemCount: widget.data?.plays?.length ?? 0,
    //   itemBuilder: (BuildContext context, int index) {
    //     final item = widget.data?.plays?[index];
    //     return Column(
    //       children: [
    //         Text(
    //           item?.name ?? '',
    //           style: context.textTheme.titleMedium?.copyWith(
    //               color: context.customTheme?.error,
    //               fontWeight: FontWeight.w600),
    //         ).paddingSymmetric(vertical: 10),
    //         GridView(
    //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 3, childAspectRatio: 1.2),
    //           physics: const NeverScrollableScrollPhysics(),
    //           shrinkWrap: true,
    //           children: list
    //               .sublist((index * 50) + 1, (index + 1) * 50)
    //               .mapIndexed((index, e) {
    //             return Container(
    //               color:
    //                   selectList.firstWhereOrNull((q) => q.id == e.id) != null
    //                       ? context.customTheme?.leftActive
    //                       : null,
    //               child: Column(
    //                 children: [
    //                   Container(
    //                     width: 40,
    //                     height: 40,
    //                     decoration: BoxDecoration(
    //                         image: DecorationImage(
    //                             image: LotteryConfig.getBallBg(
    //                                 Play(name: "${e.value}"), widget.details))),
    //                     alignment: Alignment.center,
    //                     child: Text((e.value ?? "").paddingZero(),
    //                         style: context.textTheme.bodyMedium?.copyWith(
    //                             // color: context.customTheme?.reverseFontColor,
    //                             fontWeight: FontWeight.bold)),
    //                   ),
    //                   Text(_buildOddds(),
    //                           style: context.textTheme.bodyMedium?.copyWith(
    //                               fontWeight: FontWeight.bold,
    //                               fontSize: 12,
    //                               color: selectList.firstWhereOrNull(
    //                                           (q) => q.id == e.id) !=
    //                                       null
    //                                   ? context.customTheme?.reverseFontColor
    //                                   : null))
    //                       .paddingOnly(top: 5)
    //                 ],
    //               ).onTap(() => handleSelect(e)),
    //             );
    //           }).toList(),
    //         )
    //       ],
    //     );
    //   },
    // );
  }
}
