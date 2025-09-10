import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/account/custom_special_text_span_builder.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';

class AccountPolicyWidget extends StatelessWidget {
  const AccountPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ExtendedText(
      S.current.login_bottom_protocol_text(
          S.current.app_name_text,
          S.current.hCaptcha_text,
          '[${S.current.privacy_policy_text}]',
          '[${S.current.terms_of_service_text}]'),
      specialTextSpanBuilder: CustomSpecialTextSpanBuilder(),
      style: ThemeService()
          .theme
          .textTheme
          .bodySmall
          ?.copyWith(color: ThemeService().colorScheme.onSurface),
      textAlign: TextAlign.center,
      maxLines: 2,
    );
  }

}