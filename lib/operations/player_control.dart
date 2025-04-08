import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class PlayerControl{
  final PlayerVar p = Get.find();
  final UserVar u = Get.find();
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
  }

  Future<void> shufflePlay() async {
    final rlt=await httpRequest("${u.url.value}/rest/getRandomSongs?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&size=1");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      p.handler.stop();
      return;
    }
    var tmp=rlt['subsonic-response']['randomSongs']['song'][0];
    Map<String, Object> rdSong={
      'id': tmp['id'],
      'title': tmp['title'],
      'artist': tmp['artist'],
      'playFrom': 'fullRandom',
      'duration': tmp['duration'],
      'album': tmp['album'],
      'fromId': '',
      'index': 0,
      'list': [],
    };
    p.nowPlay.value=rdSong;
    p.handler.play();
    p.isPlay.value=true;
  }
}