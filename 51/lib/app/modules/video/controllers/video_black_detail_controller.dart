import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tiyu_app/api/video_api.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/controllers/lottery_half_screen_controller.dart';
import 'package:flutter_tiyu_app/app/modules/video/controllers/video_controller.dart';
import 'package:flutter_tiyu_app/app/modules/video/data/video_detail_bean.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../home/controllers/new_home_controller.dart';
import '../data/video_home_bean.dart';
import '../widget/custom_video_controller_widget.dart';
import '../widget/full_screen_click_widget.dart';

class VideoBlackDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Rx<VideoPlayerController?> videoPlayerController =
      Rx<VideoPlayerController?>(null);
  Rx<TabController?> tabController = Rx<TabController?>(null);
  ChewieController? chewieController;
  NewHomeController homeController = Get.find();
  RxBool isPlay = false.obs;
  RxBool isShowController = false.obs;
  // late VideoSecondList detailBean;
  RxDouble progress = 0.0.obs;
  RxInt currentTabIndex = 0.obs; //当前选中的底部tab分类

  bool isTouch = false; //是否正在拖动

  RxString currentTime = "".obs; //当前时间
  RxString totalTime = "".obs; //总时长
  final Rxn<VideoDetailBean> videoDetailInfo = Rxn<VideoDetailBean>();
  RxBool isFullScreen = false.obs; //是否是全屏状态，默认false
  RxList<VideoSecondList> likeList = <VideoSecondList>[].obs;

  late VideoController videoController = Get.find();

  @override
  void onInit() async {
    super.onInit();
    tabController.value = TabController(length: 3, vsync: this);
    var videoId = Get.arguments["videoId"];
    videoDetailInfo.value = await VideoApi.reqVideoDetailData(videoId);
    likeList.value = await VideoApi.reqVideoDetailLikeData(videoId);
    // print(
    //     "输出前：${Uri.parse("${videoDetailInfo.value?.href}")}  输出后：${detailBean.href}");
    videoPlayerController.value = VideoPlayerController.networkUrl(
        Uri.parse("${videoDetailInfo.value?.href}"));

    videoPlayerController.value!.initialize().then((_) {
      chewieController = ChewieController(
          videoPlayerController: videoPlayerController.value!,
          autoPlay: false,
          looping: true,
          deviceOrientationsOnEnterFullScreen: [
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ],
          deviceOrientationsAfterFullScreen: [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
          overlay: const FullScreenClickWidget(
            isBlack: true,
          ),
          // fullScreenByDefault: true,
          customControls: const CustomVideoControllerWidget(
            isBlack: true,
          ))
        ..addListener(() {
          isFullScreen.value = chewieController!.isFullScreen;
        });
      videoPlayerController.refresh();
    });
    // 监听播放器状态变化
    videoPlayerController.value!.addListener(() {
      final duration =
          videoPlayerController.value!.value.duration.inMilliseconds.toDouble();
      final position =
          videoPlayerController.value!.value.position.inMilliseconds.toDouble();
      totalTime.value =
          formatDuration(videoPlayerController.value!.value.duration);
      currentTime.value =
          formatDuration(videoPlayerController.value!.value.position);
      // 计算播放进度
      if (duration > 0) {
        //如果正在拖动，先不更新进度
        if (isTouch) return;
        progress.value = (position / duration).clamp(0.0, 1.0);
      }

      // // 计算缓冲进度
      // final buffered = videoPlayerController.value!.value.buffered;
      // if (buffered.isNotEmpty) {
      //   final bufferedDuration = buffered.last.end.inMilliseconds.toDouble();
      //   mBuffered.value = (bufferedDuration / duration).clamp(0.0, 1.0);
      // }
    });
  }

  //手动进行一次资源释放
  void disposePlayer() {
    videoPlayerController.value?.dispose();
    chewieController?.dispose();
  }

  @override
  void onClose() {
    tabController.value?.dispose();
    disposePlayer();
    super.onClose();
  }

  void showOrHideController() {
    isShowController.value = !isShowController.value;
  }

  //播放或者暂停
  void playOrPause() {
    if (chewieController!.isPlaying) {
      chewieController!.pause();
      isPlay.value = false;
    } else {
      chewieController!.play();
      isPlay.value = true;
    }
  }

  //改变播放进度条
  void changePlayProgress(double position) {
    progress.value = position;
  }

  //全屏模式
  void fullScreen() {
    if (chewieController!.isFullScreen) {
      chewieController!.exitFullScreen();
    } else {
      chewieController!.enterFullScreen();
    }
  }

  //视频跳转到对应进度
  void seekTo(double position) {
    final duration =
        videoPlayerController.value!.value.duration.inMilliseconds.toDouble();
    final newPosition = position * duration;
    videoPlayerController.value!
        .seekTo(Duration(milliseconds: newPosition.toInt()));
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else if (minutes > 0) {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(seconds)}';
    }
  }

  void setCurrentTabIndex(int index) {
    if (index == 2) {
      HalfScreenController.showHalfScreenImage(
          onClose: () => {currentTabIndex.value = 0});
    } else {
      currentTabIndex.value = index;
    }
  }
}
