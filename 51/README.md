# flutter_tiyu_app

flutter doctor -v  
[✓] Flutter (Channel stable, 3.24.5, on macOS 14.2.1 23C71 darwin-x64, locale en-PH)
• Flutter version 3.24.5 on channel stable at /Users/a123/development/flutter
• Upstream repository https://github.com/flutter/flutter.git
• Framework revision dec2ee5c1f (12 days ago), 2024-11-13 11:13:06 -0800
• Engine revision a18df97ca5
• Dart version 3.5.4
• DevTools version 2.37.3

[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.1)
• Android SDK at /Users/a123/Library/Android/sdk
• Platform android-34, build-tools 33.0.1
• Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
• Java version OpenJDK Runtime Environment (build 17.0.10+0-17.0.10b1087.21-11572160)
• All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 15.4)
• Xcode at /Applications/Xcode.app/Contents/Developer
• Build 15F31d
• CocoaPods version 1.14.3

[✓] Android Studio (version 2023.3)
• Android Studio at /Applications/Android Studio.app/Contents
• Flutter plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/9212-flutter
• Dart plugin can be installed from:
🔨 https://plugins.jetbrains.com/plugin/6351-dart
• Java version OpenJDK Runtime Environment (build 17.0.10+0-17.0.10b1087.21-11572160)

flutter create --org com.ace --platforms=android,ios flutter_tiyu_app
flutter pub add encrypt
flutter pub add intl

keytool -genkey -v -keystore tiyu-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key0824

flutter build apk --release
fvm flutter build apk --release --target-platform android-arm,android-arm64

fvm flutter build ios --release
open ios/Runner.xcworkspace

shorebird login

shorebird init
shorebird init --force

shorebird release android --flutter-version 3.24.5 --artifact apk
shorebird patch --platforms=android --release-version=1.0.1+22

shorebird release ios --flutter-version 3.24.5
shorebird patch --platforms=ios --release-version=1.0.1+22

App 需要重启两次

1. Re-launch the app once to download the patch.
2. Re-launch the app again to boot from the patch.

## 支持 10 种语言

1. 英文 app_en.arb
2. 中文简体 app_zh.arb
<!-- 3. 中文繁体 app_zh_Hant.arb -->
3. 印度语 app_hi.arb
4. 阿拉伯语 app_ar.arb
5. 西班牙语 app_es.arb
6. 印尼语 app_id.arb
<!-- 8. 马来语 app_ms.arb -->
7. 葡萄牙语 app_pt.arb
8. 泰语 app_th.arb
9. 土耳其语 app_tr.arb
10. 越南语 app_vi.arb

## 包名

dev_dependencies:
change_app_package_name: ^1.4.0

dart run change_app_package_name:main com.aomen.grand.lisboa

## 图标

dart run flutter_launcher_icons

## 资源

dart run build_runner build


## 换肤
所有颜色都加到 assets/json/theme.json 中， 添加完成后执行
sh ./bin/start.sh 

调用方法 
- 主题色
    context.theme.primaryColor
- 其他配色
  例如页面背景色
    context.customTheme?.pageBg

