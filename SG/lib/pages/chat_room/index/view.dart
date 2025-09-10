import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/chat_room/rule/view.dart';
import 'package:flutter_bet/pages/chat_room/widgets/chat_message_card.dart';
import 'package:flutter_bet/services/chat_room_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_rotating_arrow.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/image_name.dart';
import '../../../widget/bottom/custom_close_button.dart';
import '../../../widget/network_image/custom_network_image_placeholder.dart';
import '../../main/code.dart';
import '../../main/logic.dart';
import 'logic.dart';
import '../../../routes/routes.dart';

class ChatRoomPage extends BaseView<ChatRoomLogic> {
  final GlobalKey<RotatingArrowState> _rotatingArrowKey = GlobalKey<RotatingArrowState>();
  final GlobalKey<ScalingTextState> _scalingKey = GlobalKey<ScalingTextState>();

  void _startAnimation(GlobalKey<RotatingArrowState> key) {
    key.currentState?.startAnimation();
  }

  void _startScaleAnimation(GlobalKey<ScalingTextState> key) {
    key.currentState?.startAnimation();
  }

  @override
  Widget buildBody(BuildContext context) {
    return _buildContentView(context);
  }

  _buildContentView(BuildContext context) {
    return Column(
        children: [
          controller.isInitialized.value ? _buildContentListView() : _buildShimmerView(),
          Container(
            color: AppThemes.chatRooCardColor,
            padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
            // margin: EdgeInsets.only(bottom: AppValues.barBottomHeight),
            child: Column(
              children: [
                const SizedBox(
                  height: AppValues.largePadding,
                ),
                GestureDetector(
                  onTap: () => controller.showKeyboard(),
                  child: Obx(() {
                    return CustomMainTextField(
                      isEmoji: true,
                      isHighlight: controller.emojiHighlight.value,
                      onTap: controller.onTap,
                      controller: controller.textCtrl,
                      text: controller.inputText.value,
                      style: TextStyle(fontSize: 15,color: ThemeService().theme.colorScheme.onBackground,fontWeight: FontWeight.w600),
                      maxLines: 2,
                      maxLength: inputMaxLength,
                      hintText: S.current.please_input_message,
                      hintColor: const Color(0xff5b646b),
                      focusNode: controller.focusNode,
                      enabled: controller.isFocus.value,
                      inputCompletionCallBack: (value, isSubmit) =>
                          controller.onInputMessageComplete(value),
                      inputCallBack: (value) => controller.onInputMessage(value),
                    );
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: AppThemes.chatRoomOnlineGreenColor,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    const SizedBox(
                      width: AppValues.smallPadding,
                    ),
                    CustomText(
                      S.current.chat_room_online_text(controller.online.value),
                      style: ThemeService()
                          .theme
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600,fontSize: 12),
                      textColorStyle: CustomTextColorStyle.normal,
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(() {
                          return CustomText(
                            '${controller.maxLessTextLen.value}',
                            textColorStyle: CustomTextColorStyle.normal,
                          );
                        }),
                        const SizedBox(
                          width: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            showCustomChatRoomRuleWidgetWidget(context: context);
                          },
                          child: Container(
                              width: 46,
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                boxShadow: const [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25),blurRadius: 4,offset: Offset(0, 4))],
                                color: AppThemes.lineGreen,
                                borderRadius: BorderRadius.circular(4)
                              ),
                              child: Image.asset('assets/images/chat_room/ic_rule_top.png')
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          width: 66,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppThemes.chatRoomOnlineGreenColor,
                            borderRadius: BorderRadius.circular(4)
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.bounceIn, // 使用弹性曲线
                            transform: Matrix4.identity()..scale(controller.scaleBtn.value),
                            transformAlignment: Alignment.center,
                            child: CustomBigMainButton(
                              title: S.current.message_send_button_text,
                              textColor: controller.scaleBtn.value == 1 ? ThemeService().colorScheme.onInverseSurface : const Color(0x7f000000),
                              colorStyle: CustomButtonColorStyle.tertiary,
                              onTap: (btnCtr) {
                                if (controller.submitText.isEmpty) {
                                  controller.scaleBtn.value = 0.9;
                                  Future.delayed(const Duration(milliseconds: 200), () {
                                    controller.scaleBtn.value = 1.0;
                                  });
                                  return;
                                }
                                controller.onSubmit(context, btnCtr);
                              },
                            )
                          ),
                        )
                      ],
                    )),
                  ],
                ),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                // SizedBox(
                //   height: WidgetUtil.getBottomPaddingHeight(context),
                // ),
              ],
            ),
          ),
          // Obx(() => Container(height: controller.isFocus.value ? 0 : 75,))
        ],
    );
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return CustomAppBar(
      backgroundColor: const Color(0xFF12212D),
      showLeading: false,
      titleView: _buildChatRoomAppBar(context),
    );
  }

  Widget _buildChatRoomAppBar(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            controller.scale.value = 0.9;
            Future.delayed(const Duration(milliseconds: 100), () {
              controller.scale.value = 1.0;
            });
            _startAnimation(_rotatingArrowKey);
            _startScaleAnimation(_scalingKey);
            DialogUtils.showCustomBubbleDialog(
              context,
              _buildBubbleChild(),
              124,
              widgetKey: _scalingKey,
              globalKey: _rotatingArrowKey,
              onDismissCallback: () {
                controller.scale.value = 0.9;
                Future.delayed(const Duration(milliseconds: 100), () {
                  controller.scale.value = 1.0;
                });
              }
            );
          },
          child: Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceIn, // 使用弹性曲线
            transform: Matrix4.identity()..scale(controller.scale.value),
            child: Row(
              children: [
                SizedBox(
                    width: 14,
                    height: 14,
                    child: Obx(() {
                      return Image.asset(
                        controller.iconPath.value,
                        fit: BoxFit.fill,
                      );
                    })),
                const SizedBox(
                  width: 6,
                ),
                Obx(() {
                  return ScalingText(
                    key: _scalingKey,
                    text: 'Meibo: ${controller.currCountryText.value}',
                    textStyle: ThemeService().theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                  );
                }),
                const SizedBox(
                  width: 6,
                ),
                RotatingArrow(
                  key: _rotatingArrowKey,
                ),
              ],
            )
          ))
        ),
        const Spacer(),
        CustomCloseButton(onTap: () {
          RouteUtil.popView();
          MainLogic.of().onMenuSelected(MenuCode.GAME);
        }),
      ],
    );
  }

  Widget _buildBubbleChild() {
    final widgets = <Widget>[];
    final channelModels = ChatRoomService.sharedInstance.getChannelModels;
    for (ChatRoomChannelModel model in channelModels) {
      widgets.add(GestureDetector(
        onTap: () {
          controller.currCountryText.value = model.name;
          controller.iconPath.value = model.iconPath;
          ChatRoomService.sharedInstance.switchChannel(model);
          RouteUtil.popView();
        },
        child: SizedBox(
          height: 30,
          child: Row(
            children: [
              const SizedBox(
                width: AppValues.defaultPadding,
              ),
              SizedBox(width: 14, height: 14, child: Image.asset(model.iconPath, fit: BoxFit.fill)),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                model.name,
                textColorStyle: controller.currCountryText.value == model.name ? CustomTextColorStyle.primary : CustomTextColorStyle.dark,
                style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ));
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppValues.smallPadding),
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  // 加载中
  Widget buildLoding() {
    return Container(
      alignment: Alignment.topCenter,
      height: 150,
      child: CustomNetWorkImagePlaceholder(
        color: AppThemes.surfaceVariant.withOpacity(0),
        placeholderType: NetWorkImagePlaceholderType.loading,
      ),
    );
  }

  Widget _buildContentListView() {
    return Expanded(
      child: Stack(
        children: [
          Obx(() {
            return ListView.builder(
              padding: const EdgeInsets.only(top: AppValues.defaultPadding),
              reverse: true,
              controller: controller.scrollController,
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final model = controller.messages[index];
                return ChatMessageCard(
                  model: model,
                );
              },
            );
          }),
          Positioned.fill(
            child: _buildEmojiView(),
          ),
          Positioned(
            bottom: 0,
            child: _atNameView(),
          )
        ],
      )
    );
  }

  // 骨架屏效果
  Widget _buildShimmerView() {
    return Expanded(
        child: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.only(top: AppValues.defaultPadding),
              controller: controller.scrollController,
              itemCount: 9,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppThemes.chatRooCardColor,
                    borderRadius: BorderRadius.circular(AppValues.smallRadius),
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding)
                      .copyWith(bottom: AppValues.defaultPadding),
                  child: Column(
                    children: [
                      if (index == 0 || index == 2 || index == 4)
                        Shimmer.fromColors(
                            baseColor: AppThemes.chatRooCardColor,
                            highlightColor: AppThemes.textColorLightGrey,
                            child: Container(
                              width: double.infinity,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: AppThemes.chatRooCardColor,
                                  borderRadius: BorderRadius.circular(3)),
                              margin: const EdgeInsets.only(left: 2, right: 180, bottom: 2),
                            )),
                      if (index == 0 || index == 1 || index == 2 || index == 3 || index == 4)
                        Shimmer.fromColors(
                            baseColor: AppThemes.chatRooCardColor,
                            highlightColor: AppThemes.textColorLightGrey,
                            child: Container(
                              width: double.infinity,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: AppThemes.chatRooCardColor,
                                  borderRadius: BorderRadius.circular(3)),
                              margin: const EdgeInsets.only(left: 2, right: 80, bottom: 2),
                            )),
                      Shimmer.fromColors(
                          baseColor: AppThemes.chatRooCardColor,
                          highlightColor: AppThemes.textColorLightGrey,
                          child: Container(
                            width: double.infinity,
                            height: 20,
                            decoration: BoxDecoration(
                                color: AppThemes.chatRooCardColor,
                                borderRadius: BorderRadius.circular(3)),
                            margin: const EdgeInsets.only(left: 2, right: 20),
                          )),
                    ],
                  ),
                );
              },
            ),
            Positioned.fill(
              child: _buildEmojiView(),
            ),
            Positioned(
              bottom: 0,
              child: _atNameView(),
            )
          ],
        )
        
    );
  }

  // emojiView
  Widget _buildEmojiView() {
    return Obx(() => Visibility(
      visible: controller.showed.value,
      child: Stack(
        children: [
          GestureDetector(
            onTap: controller.onHidden,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: Get.width,
              height: 272,
              color: ThemeService().theme.scaffoldBackgroundColor,
              child: Column(
                children: [
                  Container(
                    height: 270,
                    color: AppThemes.chatRooCardColor,
                    child: Column(
                      children: [
                        Container(
                          height: 46,
                          padding: const EdgeInsets.only(left: AppValues.defaultMargin),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(S.current.random_text_563,style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                              InkWell(
                                onTap: controller.onHidden,
                                child: Container(
                                  padding: const EdgeInsets.all(AppValues.defaultMargin),
                                  child: Image.asset(ImageAssets.images('ic_closed')),
                                ),
                              )
                            ],
                          ),
                        ),
                        //emoji
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Scrollbar(
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6, //每行三列
                                  childAspectRatio: 1.0, 
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing:20,
                                ),
                                itemCount: controller.emojiList.length + controller.emojiFaceList.length,
                                itemBuilder: (context, index) {
                                  return index < controller.emojiList.length ?
                                  InkWell(
                                    onTap: () => controller.onTapEmoji(controller.emojiList[index]),
                                    child: Container(
                                      padding: const EdgeInsets.all(AppValues.margin_8),
                                      child: Image.asset(ImageAssets.emoji(controller.emojiList[index]))
                                    ),
                                  )
                                  : InkWell(
                                    onTap: () => controller.onTapEmojiFace(controller.emojiFaceList[index - controller.emojiList.length]),
                                    child: Container(
                                      padding: const EdgeInsets.all(AppValues.margin_8),
                                      child: CustomText(controller.emojiFaceList[index - controller.emojiList.length],
                                              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontSize: AppValues.fontHeadlineSmallSize))
                                    ),
                                  );
                                },
                              ),
                            )
                          )
                        )
                      ],
                    ),
                  )
                ],
              )
            )
          )
        ],
      ),
    ));
  }

  Widget _atNameView() {
    return Obx(() => Visibility(
      visible: controller.showedAt.value,
      child: Container(
        width: Get.width,
        height: controller.nameList.length > 5 ? 200 : controller.nameList.length * 40,
        color: ThemeService().colorScheme.tertiary,
        child: Obx(() => ListView.builder(
          itemCount: controller.nameList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap:() => controller.onTapAtName(controller.nameList[index].n!),
              child: Container(
                height: 40,
                color: index == 0 ? ThemeService().colorScheme.background : Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                alignment: Alignment.centerLeft,
                child: CustomText(controller.nameList[index].n!),
              ),
            );
          }
        )),
      ),
    ));
  }
}
