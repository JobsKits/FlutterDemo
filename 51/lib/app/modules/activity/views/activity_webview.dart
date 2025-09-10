import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ActivityWebview extends StatefulWidget {
  final String? html;
  final Function(double)? onChangeHeihgt;
  final bool? isScroll;
  final Function(double)? onChange;
  final bool? isScrollTop;
  final bool? showLoading;

  const ActivityWebview({
    super.key,
    this.html,
    this.showLoading,
    this.onChangeHeihgt,
    this.isScroll,
    this.onChange,
    this.isScrollTop,
  });

  @override
  State<ActivityWebview> createState() => _ActivityWebviewState();
}

class _ActivityWebviewState extends State<ActivityWebview>
    with AutomaticKeepAliveClientMixin {
  WebViewController? controller;
  bool _isLoadingInitialPage = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("Print", onMessageReceived: (message) {
        final top = (double.tryParse(message.message) ?? 0);
        if (top <= 0) {
          widget.onChange?.call(top);
        }
      })
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if (_isLoadingInitialPage && Platform.isIOS) {
            _isLoadingInitialPage = false;
            return NavigationDecision.navigate;
          }
          return NavigationDecision.navigate;
        },
        onPageFinished: (url) async {
          // 页面加载完成后动态获取 HTML 高度
          await Future.delayed(200.milliseconds);
          final rawHeight = await controller?.runJavaScriptReturningResult(
            'document.getElementById("app").scrollHeight'
          );

          final cleaned = "$rawHeight".replaceAll(RegExp(r'[^0-9.]'), '');
          final height = double.tryParse(cleaned);

          if (height != null) {
            widget.onChangeHeihgt?.call(height + 20); // +20 padding
          }

          // 拦截 a 标签点击事件
          controller?.runJavaScript('''
            document.addEventListener('click', function(e) {
              e = e || window.event;
              var target = e.target || e.srcElement;
              while (target && target.tagName !== 'A') {
                target = target.parentElement;
              }
              if (target && target.tagName === 'A') {
                if (!target.href.includes("http") && target.href!="") {
                  e.preventDefault();
                  Print.postMessage(target.href);
                }
                return false;
              }
            }, false);
          ''');
        },
      ))
      ..loadHtmlString(getHtml(widget.html ?? ''));
  }

  String getHtml(String content) {
    final newContent = content;

    final res = """
<!DOCTYPE html>
<html>
  <head>
    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
    <style>
      * {
        margin: 0;
        padding: 0;
      }
      html, body {
        width: 100% !important;
        height: auto !important;
        overflow: auto !important;
        -webkit-user-select: none;
        user-select: none;
      }
      img {
        max-width: 100%!important;
        height: auto!important;
      }
      table {
        width:100%!important;
        border-collapse: collapse !important;
      }
      table tbody tr td {
        border: 1px solid #000 !important;
        text-align: center;
        vertical-align: middle;
      }
      #app {
        width: 100% !important;
        height: auto !important;
        overflow: auto !important;
      }
    </style>
  </head>
  <body>
    <div id="app">$newContent</div>
  </body>
</html>
""";

    return res;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (controller == null) return const SizedBox();
    return WebViewWidget(controller: controller!);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
