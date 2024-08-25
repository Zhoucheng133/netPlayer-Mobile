import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/operations/play_check.dart';
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class Operations{

  DataGet dataGet=DataGet();
  UserVar u = Get.put(UserVar());
  LsVar l=Get.put(LsVar());
  PlayerVar p=Get.put(PlayerVar());

  Future<void> renamePlayList(String id, String newname, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/updatePlaylist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&playlistId=$id&name=$newname");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.errDialog('重命名歌单失败', "请检查你的网络连接", context);
      }
      return;
    }else{
      if(context.mounted){
        dataGet.getPlayLists(context);
      }
    }
    return;
  }

  Future<void> delPlayList(String id, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/deletePlaylist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=$id");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.errDialog('删除歌单失败', "请检查你的网络连接", context);
      }
      return;
    }else{
      if(context.mounted){
        dataGet.getPlayLists(context);
      }
    }
  }

  Future<void> newPlayList(String name, BuildContext context) async {
    if(name.isEmpty){
      dataGet.errDialog('创建歌单失败', '歌单名称不能为空', context);
      return;
    }
    final rlt=await httpRequest("${u.url.value}/rest/createPlaylist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&name=$name");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.errDialog('创建歌单失败', "请检查你的网络连接", context);
      }
    }else{
      if(context.mounted){
        dataGet.getPlayLists(context);
      }
    }
  }

  Future<void> love(String id, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/star?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=$id");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.errDialog('喜欢歌曲失败', "请检查你的网络连接", context);
      }
      return;
    }else{
      if(context.mounted){
        l.loved.value=await dataGet.getLoved(context);
      }
      if(context.mounted){
        PlayCheck().check(context);
      }
    }
  }

  Future<void> delove(String id, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/unstar?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=$id");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.errDialog('取消喜欢歌曲失败', "请检查你的网络连接", context);
      }
      return;
    }else{
      if(context.mounted){
        l.loved.value=await dataGet.getLoved(context);
      }
      if(context.mounted){
        PlayCheck().check(context);
      }
    }
  }

  Future<void> addToList(String songId, String listId, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/updatePlaylist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&playlistId=$listId&songIdToAdd=$songId");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.errDialog('添加到歌单失败', "请检查你的网络连接", context);
      }
      return;
    }else{
      if(context.mounted){
        dataGet.getPlayLists(context);
      }
      if(context.mounted){
        PlayCheck().check(context);
      }
    }
  }

  Future<bool> deList(int songIndex, String listId, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/updatePlaylist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&playlistId=$listId&songIndexToRemove=$songIndex");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.errDialog('从歌单中删除失败', "请检查你的网络连接", context);
      }
      return false;
    }else{
      if(context.mounted){
        PlayCheck().check(context);
      }
      return true;
    }
  }

  int timeToMilliseconds(timeString) {
    List<String> parts = timeString.split(':');
    int minutes = int.parse(parts[0]);
    List<String> secondsParts = parts[1].split('.');
    int seconds = int.parse(secondsParts[0]);
    int milliseconds = int.parse(secondsParts[1]);

    // 将分钟、秒和毫秒转换为总毫秒数
    return (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;
  }

  Future<void> getLyric(dynamic val) async {
    p.lyricLine.value=0;
    if(val['id']!=''){
      p.lyric.value=[
        {
          'time': 0,
          'content': "正在查找歌词...",
        }
      ];
    }
    final title=p.nowPlay['title'];
    final album=p.nowPlay['album'];
    final artist=p.nowPlay['artist'];
    final duration=p.nowPlay['duration'];
    final rlt= await httpRequest('https://lrclib.net/api/get?artist_name=$artist&track_name=$title&album_name=$album&duration=$duration');
    var response=rlt['syncedLyrics']??"";
    if(response==''){
      p.lyric.value=[
        {
          'time': 0,
          'content': '没有找到歌词',
        }
      ];
    }else{
      List lyricCovert=[];
      List<String> lines = LineSplitter.split(response).toList();
      for(String line in lines){
        int pos1=line.indexOf("[");
        int pos2=line.indexOf("]");
        lyricCovert.add({
          'time': timeToMilliseconds(line.substring(pos1+1, pos2)),
          'content': line.substring(pos2 + 1).trim(),
        });
      }
      p.lyric.value=lyricCovert;
    }
  }
}