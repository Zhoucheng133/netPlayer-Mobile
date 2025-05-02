import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/service/handler.dart';
class PlayerVar extends GetxController{

  Future<void> initPlayer() async {
    handler=await AudioService.init(
      builder: () => Handler(),
      config: const AudioServiceConfig(
        androidStopForegroundOnPause: false,
        androidNotificationChannelId: 'zhouc.netPlayer.channel.audio',
        androidNotificationChannelName: 'Music playback',
      ),
    );
  }
  
  PlayerVar(){
    initPlayer();
  }

  RxMap<String, dynamic> nowPlay={
    'id': '',
    'title': '没有播放的歌曲',
    'artist': '/',
    'playFrom': '',
    'duration': 0,  // 注意这里使用的是秒~1000ms
    'fromId': '',   // 如果不适用为空
    'index': 0,
    'album': '',
    'list': [],
  }.obs;

  late AudioHandler handler;
  // 播放模式, 可选值为: list, random, repeat
  RxString playMode='list'.obs;
  // 随机播放所有歌曲
  // 弃用，通过p.nowPlay['playFrom']=='fullRandom'?来判定
  // RxBool fullRandom=false.obs;
  // 播放进度, 注意单位为毫秒~1000ms=1s
  RxInt playProgress=0.obs;
  // 歌词内容
  RxList lyric=[].obs;
  // 当前歌词到多少行了
  RxInt lyricLine=0.obs;
  // 正在播放
  RxBool isPlay=false.obs;
  RxBool switchHero=false.obs;

  // 歌词字体大小
  RxInt fontSize=18.obs;

  var coverFuture = Rx<Uint8List?>(null);
}