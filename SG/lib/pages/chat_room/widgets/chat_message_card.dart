import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/chat_message.dart';
import 'package:flutter_bet/pages/chat_room/emoji/emoji.dart';
import 'package:flutter_bet/pages/chat_room/user_info/view.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:flutter_bet/utils/date_util.dart';
import 'package:flutter_bet/utils/image_name.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import '../../../model/user.dart';
import '../../../services/account_service.dart';
import '../../../services/theme/theme_service.dart';
import '../index/logic.dart';

class ChatMessageCard extends StatelessWidget {
  final ChatMessageModel model;

  const ChatMessageCard({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        model.showed?? false ?
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding)
              .copyWith(bottom: AppValues.margin_8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(DateUtil.getWeekdayByMs(model.t!*1000,languageCode: globalController.isChinese()?'zh':'en'),textColorStyle: CustomTextColorStyle.secondary,
                style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontSize: 10)),
              CustomText(DateUtil.formatDateMs(model.t!*1000, format: 'HH:mm'),textColorStyle: CustomTextColorStyle.secondary,
                style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontSize: 10)),
            ],
          ),
        )
         : Container(),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppThemes.chatRooCardColor,
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: AppValues.halfMargin,horizontal: AppValues.defaultMargin),
          margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding)
              .copyWith(bottom: AppValues.halfMargin),
          child: ExtendedText(
            '%G${model.v??'0'} ${model.n}%G %N${model.n}%N: ${model.c} ',
            specialTextSpanBuilder: CustomSpecialTextSpanBuilder(),
            textAlign: TextAlign.left,
            onSpecialTextTap: (parameter) {
              print(parameter.toString());
              showCustomChatRoomUserInfoWidget(context: context,name: parameter);
            },
          ),
        )
      ],
    );
  }
}

class CustomSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      required int index}) {
    if (flag == '') {
      return null;
    }
    if (isStart(flag, _GradeSpecialText.flag)) {
      return _GradeSpecialText(textStyle,
          start: index - (_GradeSpecialText.flag.length - 1));
    }
    if (isStart(flag, _NickNameSpecialText.flag)) {
      return _NickNameSpecialText(textStyle,onTap,
          start: index - (_NickNameSpecialText.flag.length - 1));
    }
    if (isStart(flag, _EmojiSpecialText.flag)) {
      return _EmojiSpecialText(textStyle,
          start: index - (_EmojiSpecialText.flag.length - 1));
    }
    if (isStart(flag, _AtSpecialText.flag)) {
      return _AtSpecialText(textStyle,onTap,
          start: index - (_AtSpecialText.flag.length - 1));
    }

    return null;
  }
}

class _GradeSpecialText extends SpecialText {
  _GradeSpecialText(TextStyle? textStyle,
      {this.start})
      : super(_GradeSpecialText.flag, '%G', textStyle);
  static const String flag = '%G';
  final int? start;

  @override
  InlineSpan finishText() {
    final String text = getContent();
    String vip = text.split(' ')[0];
    final User user = AccountService.sharedInstance.currentUser??User(username: ' !@# ');
    final String self = user.username!;
    if (text.contains(self)) {
      return SpecialTextSpan(
        text: 'ME',
        actualText: toString(),
        start: start!,
        style: textStyle?.copyWith(fontWeight: FontWeight.w600),
      );
    }
    if (vip.isEmpty)vip = '0';
    if (int.parse(vip) > 10) vip = '10';
    if (int.parse(vip) < 0) vip = '0';
    return ImageSpan(
      AssetImage(
        'assets/images/chat_room/vip/vip_$vip.png',
      ),
      // actualText: key,
      imageWidth: 20,
      imageHeight: 20,
      start: start!,
      fit: BoxFit.fill,
      alignment: PlaceholderAlignment.middle,
    );
  }
}

class _NickNameSpecialText extends SpecialText {
  _NickNameSpecialText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap,{this.start})
      : super(_GradeSpecialText.flag, '%N', textStyle,onTap: onTap);
  static const String flag = '%N';
  final int? start;

  @override
  InlineSpan finishText() {
    final String text = getContent();
    return SpecialTextSpan(
      text: text,
      actualText: toString(),
      start: start!,
      style: textStyle?.copyWith(
          color: CustomTextColorStyle.secondary.value,
          fontWeight: FontWeight.w600),
      recognizer: (TapGestureRecognizer()
        ..onTap = () {
          if (onTap != null) {
            onTap!(text);
          }
        }),
    );
  }
}

class _EmojiSpecialText extends SpecialText {
  _EmojiSpecialText(TextStyle? textStyle,
      {this.start})
      : super(_EmojiSpecialText.flag, ':%', textStyle);
  static const String flag = '%:';
  final int? start;

  @override
  InlineSpan finishText() {
    final String text = getContent();
    final emojiList = Emoji.list();
    for (var element in emojiList) {
      if (text == element) {
        return ImageSpan(
          AssetImage(
            ImageAssets.emoji(text)
          ),
          // actualText: key,
          imageWidth: 20,
          imageHeight: 20,
          start: start!,
          fit: BoxFit.fill,
          alignment: PlaceholderAlignment.middle,
        );
      }
    }
    return SpecialTextSpan(
      text: toString(),
    );
  }
}

class _AtSpecialText extends SpecialText {
  _AtSpecialText(TextStyle? textStyle, SpecialTextGestureTapCallback? onTap,{this.start})
      : super(_AtSpecialText.flag, ' ', textStyle,onTap: onTap);
  static const String flag = '@';
  final int? start;

  @override
  InlineSpan finishText() {
    final String text =' ${toString()} ';
    final String name = getContent();
    final User user = AccountService.sharedInstance.currentUser??User(username: ' !@# ');
    final String self = user.username!;
    final controller = Get.find<ChatRoomLogic>();
    for (var element in controller.nameAllList) {
      if (element.n == name) {
        return BackgroundTextSpan(
          text: text,
          background: Paint()..color = self == name ? const Color(0xff962EFF) : const Color(0xff0f1e28),
          paintBackground: (backgroundTextSpan, canvas, offset, painter, rect, {endOffset, wholeTextPainter}) {
            Rect textRect = Offset(offset.dx, offset.dy - 1) & Size(painter!.size.width -4, 20);
            canvas.clipPath(Path()
              ..addRRect(BorderRadius.circular(2)
                  .resolve(painter.textDirection)
                  .toRRect(textRect)));
            canvas.drawRect(textRect, Paint()..color = self == name ? const Color(0xff962EFF) : const Color(0xff0f1e28));
            return true;
          },
          style: textStyle?.copyWith(
              color: CustomTextColorStyle.secondary.value,
              fontWeight: FontWeight.w600),
          recognizer: (TapGestureRecognizer()
            ..onTap = () {
              if (onTap != null) {
                onTap!(name);
              }
            }),
        );
      }
    }
    return SpecialTextSpan(
      text: toString(),
    );
  }
}
