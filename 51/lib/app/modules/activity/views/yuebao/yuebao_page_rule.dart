import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_yuebao_page.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// 利息规则
class YuebaoPageRule extends StatelessWidget {
  const YuebaoPageRule({super.key});

  @override
  Widget build(BuildContext context) {
    final ControllerYuebaoPage controller = Get.find();
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: context.customTheme?.pageTwoBg,
        ),
        width: double.infinity,
        padding:
            EdgeInsets.only(top: 58.h, left: 58.w, right: 58.w, bottom: 58.h),
        child: HtmlWidget(
          controller.remark.value,
          textStyle: TextStyle(
            fontSize: 39.sp,
            color: context.customTheme?.title3Color,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem({
    required String title,
    required List<String> content,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: const Color(colorFFFFFF),
      ),
      width: double.infinity,
      // padding: EdgeInsets.symmetric(horizontal: 58.w, vertical: 0.h),
      padding: EdgeInsets.only(left: 58.w, right: 58.w, bottom: 58.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // '1.收益介绍：存入余额宝的金额，至少满足一个完整周期才能产生利息，若中途提前转出则该周期不计算收益，例如：当前结算周期为10分钟，则2023-01-01 00:00:01转入的金额，将在2023-01-01 00:10:01产生第一个周期利息;'
          //   '\n\n2.结算周期：当前利息的结算周期为10分钟;'
          //   '\n\n3.年利率：当前年利率为38%;'
          //   '\n\n4.计算公式：利息收益=存入金额 * 年利率 / 结算周期;'
          //   '\n\n5.举例说明：A于2024-01-01 00:00:01存入10,000，年利率为38%，结算周期为10分钟，则于2024-01-01 00:10:01获得首次利息收益，计算方式如下:首次利息 =100,000*38%/365天/1440分钟*10分钟 = 0.7229'
          //   '\n\n6.每次转入金额必须大于等于1（即≥1），转入金额无上限，越多收益越大;'
          //   '\n\n7.当前利息不封顶，记得定期或经常来领取收益，以免错过更多收益哦;'
          //   '\n\n8.领取时间：当前为隔天领取，即当天产生的利息，要等到第二天0点后才能领取;'
          //   '\n\n9.稽核倍数：当前稽核倍数为5倍（投注流水要求），即所领取的利息，需要进行投注后，才能提现，投注不限有效平台,仅限于所领取的利息需要稽核，所转入转出的本金则无稽核要求;'
          //   '\n\n10.活动声明：本功能仅限账号本人进行正常游戏投注，禁止租借账号、无风险投注(对赌、对刷、低赔刷水)、恶意套利、使用外挂程式、机器人、利用协议、漏洞、接口、群控或其他技术手段参与，一经查核属实，本平台有权终止会员登录、暂停会员使用网站、及没收奖金和不当盈利的权利，无需特别通知;'
          //   '\n\n11.解释说明：会员领取余额宝奖励时，本平台将默认会员同意且遵守对应条件等相关规定，为避免文字理解歧义，本平台保有本活动最终解释权。'
          SizedBox(height: 15.h),
          Text(
            '收益介绍：',
            style: TextStyle(
              fontSize: 48.sp,
              color: const Color(color313131),
              height: 1.2,
            ),
          ),
          SizedBox(height: 15.h),
          Text(
            '存入余额宝的金额，至少满足一个完整周期才能产生利息，若中途提前转出则该周期不计算收益，例如：当前结算周期为10分钟，则2023-01-01 00:00:01转入的金额，将在2023-01-01 00:10:01产生第一个周期利息;',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            '结算周期：',
            style: TextStyle(
              fontSize: 48.sp,
              color: const Color(color313131),
              height: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '结算周期：当前利息的结算周期为10分钟;',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            '年利率：',
            style: TextStyle(
              fontSize: 48.sp,
              color: const Color(color313131),
              height: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '当前年利率为38%;',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            '计算公式：',
            style: TextStyle(
              fontSize: 48.sp,
              color: const Color(color313131),
              height: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '利息收益=存入金额 * 年利率 / 结算周期;',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            '举例说明：',
            style: TextStyle(
              fontSize: 48.sp,
              color: const Color(color313131),
              height: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'A于2024-01-01 00:00:01存入10,000，年利率为38%，结算周期为10分钟，则于2024-01-01 00:10:01获得首次利息收益，计算方式如下:首次利息 =100,000*38%/365天/1440分钟*10分钟 = 0.7229;',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            '每次转入金额必须大于等于1（即≥1），转入金额无上限，越多收益越大;',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            '当前利息不封顶，记得定期或经常来领取收益，以免错过更多收益哦;',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            '领取时间：',
            style: TextStyle(
              fontSize: 48.sp,
              color: const Color(color313131),
              height: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '当前为隔天领取，即当天产生的利息，要等到第二天0点后才能领取;',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            '稽核倍数：',
            style: TextStyle(
              fontSize: 48.sp,
              color: const Color(color313131),
              height: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '当前稽核倍数为5倍（投注流水要求），即所领取的利息，需要进行投注后，才能提现，投注不限有效平台,仅限于所领取的利息需要稽核，所转入转出的本金则无稽核要求;',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            '活动声明：',
            style: TextStyle(
              fontSize: 48.sp,
              color: const Color(color313131),
              height: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '活动声明：本功能仅限账号本人进行正常游戏投注，禁止租借账号、无风险投注(对赌、对刷、低赔刷水)、恶意套利、使用外挂程式、机器人、利用协议、漏洞、接口、群控或其他技术手段参与，一经查核属实，本平台有权终止会员登录、暂停会员使用网站、及没收奖金和不当盈利的权利，无需特别通知;',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            '解释说明：',
            style: TextStyle(
              fontSize: 48.sp,
              color: const Color(color313131),
              height: 1.2,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '会员领取余额宝奖励时，本平台将默认会员同意且遵守对应条件等相关规定，为避免文字理解歧义，本平台保有本活动最终解释权。',
            style: TextStyle(
              fontSize: 42.sp,
              color: const Color(color666666),
              height: 1.2,
            ),
          ),

          // if (title.isEmpty) ... [
          //   Text(
          //     title,
          //     style: TextStyle(
          //       fontSize: 48.sp,
          //       color: const Color(color313131),
          //       height: 1.2,
          //     ),
          //   ),
          //   SizedBox(height: 20.h),
          // ],
          // ...List.generate(
          //   content.length,
          //   (index) => Padding(
          //     padding: EdgeInsets.only(top: 0.h),
          //     child: Text(
          //       content[index],
          //       style: TextStyle(
          //         fontSize: 42.sp,
          //         color: const Color(color666666),
          //         height: 1.2,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
