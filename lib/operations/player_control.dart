import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class PlayerControl{
  final PlayerVar p = Get.put(PlayerVar());
  // 播放歌曲
  Future<void> playSong(BuildContext context, String id, String title, String artist, String playFrom, int duration, String listId, int index, List list, String album) async {
    Map<String, Object> data={
      'id': id,
      'title': title,
      'artist': artist,
      'playFrom': playFrom,
      'duration': duration,
      'fromId': listId,
      'album': album,
      'index': index,
      'list': list,
    };
    p.nowPlay.value=data;
    p.handler.play();
    p.isPlay.value=true;
    // if(p.fullRandom.value){
    //   p.fullRandom.value=false;
    //   final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   await prefs.setBool('fullRandom', false);
    // }
  }
}