import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import 'responsible_logic.dart';
import 'responsible_tab_view.dart';
import 'view/self_exclusion_detail_view.dart';
import 'view/self_exclusion_time_view.dart';

class ResponsibleViewTest extends StatefulWidget {
  ResponsibleViewTest({super.key});

  final logic = Get.put(ResponsibleLogic());

  @override
  State<ResponsibleViewTest> createState() => _ResponsibleViewTestState();
}

class _ResponsibleViewTestState extends State<ResponsibleViewTest> {

  final controller = Get.find<ResponsibleLogic>();

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     color: Colors.transparent,
  //     home: Scaffold(
  //       backgroundColor: Colors.transparent,
  //       // body: PageView(
  //       //   controller: _pageController,
  //       //   children: <Widget>[
  //       //     Container(
  //       //       color: Colors.red,
  //       //       child: Center(
  //       //         child: ElevatedButton(
  //       //           onPressed: () {
  //       //             if (_pageController.hasClients) {
  //       //               _pageController.animateToPage(
  //       //                 1,
  //       //                 duration: const Duration(milliseconds: 400),
  //       //                 curve: Curves.easeInOut,
  //       //               );
  //       //             }
  //       //           },
  //       //           child: const Text('Next'),
  //       //         ),
  //       //       ),
  //       //     ),
  //       //     Container(
  //       //       color: Colors.blue,
  //       //       child: Center(
  //       //         child: ElevatedButton(
  //       //           onPressed: () {
  //       //             if (_pageController.hasClients) {
  //       //               _pageController.animateToPage(
  //       //                 0,
  //       //                 duration: const Duration(milliseconds: 400),
  //       //                 curve: Curves.easeInOut,
  //       //               );
  //       //             }
  //       //           },
  //       //           child: const Text('Previous'),
  //       //         ),
  //       //       ),
  //       //     ),
  //       //   ],
  //       // ),
  //
  //       body: LayoutBuilder(
  //         builder: (context,constraint) {
  //           return SingleChildScrollView(
  //             child: ConstrainedBox(
  //               constraints: BoxConstraints(minHeight: constraint.maxHeight),
  //               child: IntrinsicHeight(
  //                 child: Container(
  //                   margin: const EdgeInsets.symmetric(horizontal: 16),
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(AppValues.smallRadius),
  //                     color: ThemeService().colorScheme.background,
  //                   ),
  //                   child: Column(
  //                     children: [
  //                       Text("biaoti"),
  //                       _buildContent(),
  //                       // Expanded(
  //                       //   flex: 1,
  //                       //     child: Container(
  //                       //   color: Colors.red,
  //                       // ))
  //                     ],
  //                   ),
  //
  //                   // _buildContent(),
  //                 ),
  //               ),
  //             ),
  //           );
  //         }
  //       ),
  //     ),
  //   );
  // }

  _buildContent() {
    return Expanded(
      child: Container(
        color: Colors.blue,
        constraints: const BoxConstraints.expand(),
        child: SingleChildScrollView(child: Text(S.current.random_text_364)),
        // child: PageView(
        //   // controller: PageController(),
        //   controller: _pageController,
        //   children: [
        //     SingleChildScrollView(child: ResponsibleTabView()),
        //     SingleChildScrollView(child: SelfExclusionDetailView()),
        //     SingleChildScrollView(child: SelfExclusionTimeView()),
        //     SingleChildScrollView(child: Text("正文01")),
        //     SingleChildScrollView(child: Container(height: 400, child: Text("正文02"))),
        //   ],
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        // appBar: AppBar(title: const Text('SingleChildScrollView and Expanded')),
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraint) {
            log('打印：LayoutBuilder...'+constraint.toString());
            return Column(
              children: [
                Spacer(),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppValues.smallRadius),
                    color: ThemeService().colorScheme.background,
                    // color: Colors.red,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          const Text("Header"),
                          TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Item'),
                            ),
                            controller: TextEditingController(text: 'value'),
                          ),
                          Container(
                            height: 8.0,
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.greenAccent,
                              child: Column(
                                children: [
                                  const Text('Inner Header'),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      label: Text('Sub item'),
                                    ),
                                    controller: TextEditingController(text: 'sub value'),
                                  ),
                                  Expanded(
                                    // child: Container(
                                    //   // height: 200,
                                    //   constraints: const BoxConstraints.expand(),
                                    //   margin: const EdgeInsets.all(8.0),
                                    //   color: Colors.lightGreen,
                                    //   // child: const Text("Inner Body"),
                                    //   child: _buildContent2(),
                                    // ),
                                    child: _buildContent2(),
                                  ),
                                  const Text("Inner Footer"),
                                ],
                              ),
                            ),
                          ),
                          const Text("Footer"),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildContent2() {
    // return Obx(() {
    //   return IndexedStack(
    //     index: widget.logic.indexedStack.value,
    //     // sizing: StackFit.passthrough,
    //     // sizing: StackFit.loose,
    //     // index: 0,
    //     // 居中对齐，可以看上篇各种对齐方式详解
    //     // alignment: Alignment.center,
    //     children: [
    //       // ResponsibleTabView(),
    //       SelfExclusionDetailView(),
    //       SelfExclusionTimeView(),
    //     ],
    //   );
    // });

    return SingleChildScrollView(child: SelfExclusionDetailView());
  }

}
