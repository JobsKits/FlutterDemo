import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';

import 'package:get/get.dart';

class ChatCollapse extends StatefulWidget {
  final String? label;
  final String? value;
  final bool? showArrow;
  final Alignment? valueAlign;
  final Widget? actions;
  final Widget? valueWidget;
  final TextStyle? labelStyle;
  const ChatCollapse(
      {super.key,
      this.label,
      this.value,
      this.showArrow,
      this.valueAlign,
      this.actions,
      this.valueWidget,
      this.labelStyle});

  @override
  State<ChatCollapse> createState() => _ChatCollapseState();
}

class _ChatCollapseState extends State<ChatCollapse> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.black.withOpacity(.1),
          width: .5,
        ))),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Text(widget.label ?? "",
                    style: widget.labelStyle ??
                        context.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ))),
            Expanded(
                flex: 4,
                child: widget.valueWidget ??
                    Container(
                      alignment: widget.valueAlign,
                      child: Text(
                        widget.value ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    )),
            Opacity(
                opacity: (widget.showArrow ?? false) ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    color: const Color(0xff8E9FA1),
                    size: 20,
                  ),
                )),
            widget.actions ?? const SizedBox()
          ],
        ));
  }
}
