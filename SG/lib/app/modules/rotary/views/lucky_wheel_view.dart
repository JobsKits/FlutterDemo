import 'package:flutter_bet/app/modules/rotary/controllers/rotary_controller.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/pages/home/home_logic.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image_placeholder.dart';
import 'package:get/get.dart';
import '../../../../pages/account/register/register_widget.dart';
import '../../../../pages/activity/a_model/activity_common_params.dart';
import '../../../../services/api/api_service.dart';
import 'attend.dart';
import 'wins_view.dart';

class LuckyWheelWidget extends StatefulWidget {
  LuckyWheelWidget({
    this.showLight = true,
    this.isFull = false,
    this.id = '256610365262037311',
    this.currencyId = '701',
    this.times = 1,
    this.onTap,
    super.key
  });

  final bool? showLight;
  final bool? isFull;
  final String? id;
  final String? currencyId;
  int? times;
  final void Function(double bonus)? onTap;

  @override
  LuckyWheelWidgetState createState() => LuckyWheelWidgetState();
}

class LuckyWheelWidgetState extends State<LuckyWheelWidget> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> _animation;
  final logic = Get.find<HomeLogic>();
  final coinIcDomain = '${AppValues.defaultBranch.asset_url}/currency/';
  final coinIcExtensionName = ".webp";
  bool isRunning = false;/// 是否正在转动
  bool isClockwise = true; /// 是否顺时针
  int prizeNum = 8;/// 奖品数量
  int cyclesNum = 2;/// 最少转动圈数
  late Timer timer;
  bool shining = false;
  late Timer timerGet;
  bool shiningGet = false;
  int countGet = 8;
  bool showBonus = false;
  double bonus = 0;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 350), (Timer timer) {
      setState(() {
        shining = !shining;
      });
    });
    timerGet = Timer.periodic(const Duration(milliseconds: 10), (timer) {});
    timerGet.cancel();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController.addListener(() {
      if (animationController.status == AnimationStatus.completed) {
        //结束了
        showGet();
        // GlobalState.instance.isClickLuckyWheel.value = true;
      } else if (animationController.status == AnimationStatus.forward) {
        // print('forward');
      } else if (animationController.status == AnimationStatus.reverse) {
        // print('reverse');
      }
    });
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0,
          1.0,
          curve: Curves.easeInToLinear,
        ),
      ),
    );
    super.initState();
  }
  @override
  void dispose() {
    animationController.dispose();
    timer.cancel();
    timerGet.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return wheelView();
  }

  Widget wheelView() {
    return SizedBox(
      height: 227,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: RotationTransition(
                turns: _animation,
                child: Image.asset(
                  'assets/images/wheel/wheel.png',
                  width: 200,
                )),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/wheel/circle.png',
              width: 227,
            ),
          ),
          Visibility(
            // visible: widget.showLight!,
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                shining ? 'assets/images/wheel/light_1.png' : 'assets/images/wheel/light.png',
                width: 220,
              ),
            ),
          ),
          Visibility(
            visible: shiningGet,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 17),
                child: Image.asset(
                  'assets/images/wheel/get.png',
                  width: 76,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: buttonOnClickStartRun,
              child: Image.asset(
                'assets/images/wheel/pointer.png',
                width: 70,
              ),
            ),
          ),
          showBonus ? bonusWidget() : timesWidget(),
        ],
      ),
    );
  }
  Widget timesWidget() {
    return IgnorePointer(
      child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CustomText(
              widget.times.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ),  
          // child: SizedBox(
          //   width: 80,
          //   height: 80,
          //   // color: Colors.amber,
          //   child: Column(
          //     children: [
          //       const SizedBox(
          //         height: 13,
          //       ),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: [
          //           CustomText(
          //             (globalController.langType.value == 2 || globalController.langType.value == 3)
          //                 ? ' '
          //                 : S.current.random_text_120,
          //             style: const TextStyle(color: Colors.transparent),
          //           ),
          //           CustomText(
          //             widget.times.toString(),
          //             style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
          //           ),
          //           CustomText(
          //             S.current.random_text_120,
          //             style: const TextStyle(fontWeight: FontWeight.w500),
          //           ),
          //         ],
          //       ),
          //       CustomText(
          //         S.current.random_text_842,
          //         style: const TextStyle(fontWeight: FontWeight.w600),
          //       )
          //     ],
          //   ),
          // )
        ),
    );
  }
  Widget bonusWidget() {
    return IgnorePointer(
        child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText('+'),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: bonus), // 使用起始数字
                    duration: const Duration(seconds: 1),
                    builder: (BuildContext context, double value, Widget? child) {
                      return CustomText(
                        value.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 18),
                      );
                    },
                  )
                ],
              ),
            )));
  }

  showGet() {
    showBonus = true;
    widget.times = widget.times! - 1;
    timerGet = Timer.periodic(const Duration(milliseconds: 350), (Timer timer) {
      if (countGet > 0) {
        setState(() {
          shiningGet = !shiningGet;
        });
        countGet--;
      } else {
        timerGet.cancel();
        countGet = 8;
        isRunning = false;
        showBonus = false;
        if (widget.onTap != null) widget.onTap!(bonus);
        if (!widget.showLight!) showCustomWindsWidget(id: widget.id!, bonus: bonus);
      }
    });
  }
  getBonus() async {
    /// 大转盘 获奖结果
    print("JJH");
    print(widget.id);
    print(GlobalStateController.of().currTypeSelected.value.cur??'701');
    print("JJH");
    await ApiService.instance.getRoll(
        pid: widget.id,
        cur: GlobalStateController.of().currTypeSelected.value.cur??'701',
        success: (res) {
          print("aaa4");
          if (res['ok'] == true && res['amount'] != '0') {
            print("aaa5");
            bonus = double.parse(res['amount']);
            startAnimation(1);
          } else {
            print("aaa6");
            startAnimation(7);
          }
        },
        fail: (e) {
          //仅测试时用
          if (AppUrlsValues.appEnv != EnvName.release) {
            AlertDialog(
              title: const Text('服务器错误-仅测试时用'),
              content: const Text('大转盘 获奖结果'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('关闭'),
                ),
              ],
            );
          }
          print("aaa6");
          if (e == 'token') {
            showCustomRegisterWidget();
          }
        });
  }
  /// 点击后轮盘做360度圆周运动
  void buttonOnClickStartRun() {
    print("aaa1");
    if (isRunning == false) {
      print("aaa2");
      if (widget.times! > 0 && !widget.isFull!) {
        print("aaa3");
        getBonus();
      } else {
        // showCustomShareWidget(context: Get.context!);
        showCustomAttendViewWidget();
      }
    }
  }
  void start() {
    ///中奖编号
    int luckyName = Random().nextInt(8);
    startAnimation(luckyName);
  }
  void startAnimation(int index) {
    isRunning = true;
    logic.state.luckyRecordState = LuckyRecordState.records;
    _animation =
        Tween<double>(begin: 0, end: (isClockwise ? 1 : -1) * (cyclesNum + (1 / prizeNum) * index))
            .animate(CurvedAnimation(
          parent: animationController,
          curve: const Interval(
            0,
            1.0,
            curve: Curves.ease,
          ),
        ));
    setState(() {});
    animationController.reset();
    animationController.forward();
  }
}