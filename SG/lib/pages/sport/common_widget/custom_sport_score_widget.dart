import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/utils/text_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../services/branch/branch_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../../../widget/sport/until/custom_sport_until.dart';
import '../common_model/custom_sport_score_model.dart';
import 'package:intl/intl.dart';

///赛事详情页 以及 投注订单中需要到的 比分组件
class CustomSportScoreWidget extends StatelessWidget {
  const CustomSportScoreWidget({super.key, required this.model, required this.pol, this.padding});

  final Map<String, String>? pol;
  final CustomSportScoreModel model;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return _buildScoreView();
  }

  Widget _buildScoreView() {
    return Card(
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      // elevation: 0.5,
      // color: Colors.red,
      child: IntrinsicWidth(
        child: Container(
          height: ((pol?.keys ?? []).contains('21') || (pol?.keys ?? []).contains('22'))
              ? (96 + 32).h + 0.5
              : (96).h + 0.5,
          width: Get.width,
          child: Stack(
            children: [
              Positioned(
                child: Column(
                  children: [
                    Container(
                      // width: Get.width,
                      height: 32.h,
                      color: ThemeService().theme.colorScheme.surface,
                    ),
                    Container(
                      // width: Get.width,
                      height: 32.h,
                      color: ThemeService().theme.colorScheme.background,
                    ),
                    // Container(
                    //   width:Get.width,
                    //   // color: Colors.white.withOpacity(0.2),
                    //   color: Colors.red,
                    //   height: 0.5,
                    // ),
                    Container(
                      // width: Get.width,
                      height: 32.h,
                      color: ThemeService().theme.colorScheme.background,
                    ),
                    if ((pol?.keys ?? []).contains('21') || (pol?.keys ?? []).contains('22'))
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          // width: Get.width,
                          height: 32.h,
                          color: ThemeService().theme.colorScheme.background,
                          child:
                              Text(S.current.random_text_679 + '(${pol?['21']}-${pol?['22']})    '),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                height: (96).h + 0.5,
                // height: (96).h + 4.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //第一列，时间和队名
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            color: ThemeService().theme.colorScheme.surface,
                            child: Row(
                              children: [
                                SizedBox(width: 8.w, height: 32.h),
                                CustomText(
                                  DateFormat('HH:mm yyyy/MM/dd')
                                      .format(DateTime.fromMillisecondsSinceEpoch(
                                          (model.ed ?? 0) * 1000))
                                      .toString(),
                                  style: TextStyle(color: Color(0xFFB1BAD3)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: ThemeService().theme.colorScheme.background,
                          child: Row(
                            children: [
                              SizedBox(width: 8.w, height: 32.h),
                              CustomNetWorkImage(
                                width: 14.h,
                                height: 14.h,
                                imageUrl:
                                    BranchService.instance.current.asset_url + (model.htpic ?? ''),
                                placeholder: Image.asset(
                                  SportUntil().tabImage(true, model.si ?? 999),
                                  width: 14.w,
                                  height: 14.h,
                                ),
                                errorWidget: Image.asset(
                                  SportUntil().tabImage(true, model.si ?? 999),
                                  width: 14.w,
                                  height: 14.h,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              CustomText(TextUtil.clipping(model.htn.toString(), 20)),
                            ],
                          ),
                        ),
                        Container(
                          color: ThemeService().theme.colorScheme.background,
                          child: Row(
                            children: [
                              SizedBox(width: 8.w, height: 32.h),
                              CustomNetWorkImage(
                                width: 14.h,
                                height: 14.h,
                                imageUrl:
                                    BranchService.instance.current.asset_url + (model.atpic ?? ''),
                                placeholder: Image.asset(
                                  SportUntil().tabImage(true, model.si ?? 999),
                                  width: 14.w,
                                  height: 14.h,
                                ),
                                errorWidget: Image.asset(
                                  SportUntil().tabImage(true, model.si ?? 999),
                                  width: 14.w,
                                  height: 14.h,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              CustomText(TextUtil.clipping(model.atn.toString(),20)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Column(),
                    // Expanded(child: SizedBox()),
                    //中间列部分
                    Container(
                      alignment: Alignment.centerRight,
                      width: (pol?.keys.length ?? 0) ~/ 2 * (150 / 4) > 150
                          ? 150
                          : (pol?.keys.length ?? 0) ~/ 2 * (150 / 4),
                      // constraints: BoxConstraints(
                      //   maxWidth: 150.0,
                      // ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (pol?.keys.length ?? 0) ~/ 2,
                        itemBuilder: (context, index) {
                          List<MapEntry<String, String>?> m = (pol?.entries.toList() ?? [])
                            ..sort((a, b) {
                              return (int.parse(b?.key ?? '0')).compareTo(int.parse(a?.key ?? '0'));
                            });
                          for (int i = 0; i < m.length; i++) {
                            String key = m[0]?.key ?? '';
                            if ((int.tryParse(key ?? '') ?? 0) > 8) {
                              m.add(m.removeAt(0));
                            }
                          }

                          var h = ((m[index * 2]));
                          var a = ((m[index * 2 + 1]));

                          if (a?.key == 35 || a?.key == 36 || a?.key == 23 || a?.key == 24) {
                            return Container();
                          } else {
                            if (getT(h?.key ?? '') == 'uk') {
                              return Container();
                            } else {
                              return Column(
                                children: [
                                  Container(
                                    height: 18.h,
                                    width: 20,
                                    margin: EdgeInsets.all(8.0),
                                    // color: Colors.blue,
                                    child: Center(
                                      child: getC(h?.key ?? ''),
                                    ),
                                  ),
                                  Container(
                                    height: 18.h,
                                    width: 20,
                                    margin: EdgeInsets.all(8.0),
                                    // color: Colors.blue,
                                    child: Center(
                                      child: Text(
                                        h?.value ?? '',
                                        style: TextStyle(color: Color(0xFFB1BAD3), fontSize: 14.sp),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 18.h,
                                    width: 20,
                                    margin: EdgeInsets.all(8.0),
                                    // color: Colors.blue,
                                    child: Center(
                                      child: Text(
                                        a?.value ?? '',
                                        style: TextStyle(color: Color(0xFFB1BAD3), fontSize: 14.sp),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                          }
                        },
                      ),
                    ),
                    //最后的比分列
                    Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              SportUntil().tabImage(true, model.si ?? 999),
                              width: 14.w,
                              height: 14.h,
                              color: Colors.white,
                            ),
                            SizedBox(width: 1.w, height: 32.h),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.h,
                              color: ThemeService().theme.colorScheme.surfaceVariant,
                              child: Center(
                                child: CustomText(model.hp.toString() ?? '',
                                    style: ThemeService().theme.textTheme.bodyMedium!.copyWith(
                                        color: const Color(0xFFFF9D00),
                                        fontSize: AppValues.fontBodyMediumSize.sp,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 32.w,
                              height: 32.h,
                              color: ThemeService().theme.colorScheme.surfaceVariant,
                              child: Center(
                                child: CustomText(model.ap.toString() ?? '',
                                    style: ThemeService().theme.textTheme.bodyMedium!.copyWith(
                                        color: const Color(0xFFFF9D00),
                                        fontSize: AppValues.fontBodyMediumSize.sp,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getT(String x) {
    if (x == '3' || x == '4') {
      return 'r';
    } else if (x == '5' || x == '6') {
      return 'y';
    } else if (x == '7' || x == '8') {
      return 'c';
    } else if (x == '9' || x == '10') {
      return '1st';
    } else if (x == '11' || x == '12') {
      return '2st';
    } else if (x == '13' || x == '14') {
      return '1st';
    } else if (x == '15' || x == '16') {
      return '2st';
    } else if (x == '17' || x == '18') {
      return '3st';
    } else if (x == '19' || x == '20') {
      return '4st';
    } else if (x == '21' || x == '22') {
      return 'st';
    } else if (x == '25' || x == '26') {
      return '1st';
    } else if (x == '27' || x == '28') {
      return '2st';
    } else if (x == '29' || x == '30') {
      return '3st';
    } else if (x == '31' || x == '32') {
      return '4st';
    } else if (x == '33' || x == '34') {
      return '5st';
    } else if (x == '37' || x == '38') {
      return '1st';
    } else if (x == '39' || x == '40') {
      return '2st';
    } else if (x == '41' || x == '42') {
      return '3st';
    } else if (x == '43' || x == '44') {
      return '4st';
    } else if (x == '45' || x == '46') {
      return '5st';
    }
    return 'uk';
  }

  Widget getC(String t) {
    if (t == '3' || t == '4' || t == '5' || t == '6' || t == '7' || t == '8') {
      String n = 'sport_r.webp';
      if (t == '5' || t == '6') {
        n = 'sport_y.webp';
      } else if (t == '7' || t == '8') {
        n = 'sport_c.webp';
      }
      // assets/images/sport/s_1.webp
      return Image.asset(
        "assets/images/sport/$n",
        width: 14,
        height: 14,
      );
    } else {
      if (getT(t) == 'uk') {
        return Container();
      } else {
        return Text(
          getT(t),
          // '$index',
          style: TextStyle(color: Color(0xFFB1BAD3), fontSize: 14.sp),
        );
      }
    }
  }
}
