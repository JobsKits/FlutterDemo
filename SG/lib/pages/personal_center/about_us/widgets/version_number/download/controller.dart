import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../../utils/route_util.dart';
import '../controller.dart';

class DownloadController extends GetxController {
  DownloadController();
  final VersionNumberController logic = Get.find<VersionNumberController>();
  final value = 0.obs;

  _initData() {
    update(["download"]);
    downloadFile();
  }

  downloadFile() async{
    var permission = await checkPermission();
    if (permission){
      final directory = await getExternalStorageDirectory();
      String localPath = directory!.path;  // 本地路径
      String appName = "aaa.apk";   // apk
      String appUrl = 'https://dk0gdtx9n13r0.cloudfront.net/dev_01-18_10-53-02.apk';  // 下载路径
      if(GetPlatform.isAndroid){
        appName = "aaa.apk";   // apk
        appUrl = 'https://dk0gdtx9n13r0.cloudfront.net/dev_02-27_11-05-13.apk';  // 下载路径
      }
      String savePath = "$localPath/$appName";  // 保存路径
      await Dio().download(appUrl, savePath,onReceiveProgress: (received,total){
        if(total != -1){
          value.value = (received/total*100).round();
          // print("object------${(received/total*100).toStringAsFixed(0)}%");
        }
      },
      options: Options(
        headers: {
          "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36"
        },
        followRedirects: false,
        responseType: ResponseType.bytes, // 设置响应类型为字节
      ));
      await InstallPlugin.install(savePath);
    }else{
      // print("没有权限");
      onTap();
      logic.showError();
    }
  }

  Future<bool> checkPermission() async{
    if(GetPlatform.isAndroid){
      final status = await Permission.storage.status;  // 存储权限
      if (status != PermissionStatus.granted){  // 是否授权
        final result = await Permission.storage.request();  // 申请权限
        if (result == PermissionStatus.granted){
          return true;
        }
      }else{
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void onTap() {
    RouteUtil.popView();
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
