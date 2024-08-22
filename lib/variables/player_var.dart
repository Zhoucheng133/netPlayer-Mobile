import 'package:get/get.dart';
class PlayerVar extends GetxController{
  RxMap<String, dynamic> nowPlay={
    'id': '',
    'title': '',
    'artist': '',
    'playFrom': '',
    'duration': 0,  // 注意这里使用的是秒~1000ms
    'fromId': '',   // 如果不适用为空
    'index': 0,
    'album': '',
    'list': [],
  }.obs;

  // ignore: prefer_typing_uninitialized_variables
  var handler;
  // 播放模式, 可选值为: list, random, repeat
  RxString playMode='list'.obs;
  // 随机播放所有歌曲
  RxBool fullRandom=false.obs;
  // 播放进度, 注意单位为毫秒~1000ms=1s
  RxInt playProgress=0.obs;
  // 歌词内容
  RxList lyric=[].obs;
  // 当前歌词到多少行了
  RxInt lyricLine=0.obs;
  // 正在播放
  RxBool isPlay=false.obs;
}

class PlayerStatic{
  String version='v2.0.0';
}