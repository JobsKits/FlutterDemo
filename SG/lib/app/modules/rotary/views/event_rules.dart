import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class EventRulesView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
     return   InAppWebView(
       initialFile: 'assets/html/event_rules.html',
       initialOptions: InAppWebViewGroupOptions(
         crossPlatform: InAppWebViewOptions(transparentBackground: true),
       ),
     );
  }

}