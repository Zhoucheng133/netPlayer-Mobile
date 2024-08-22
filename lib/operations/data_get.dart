import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class DataGet{

  final UserVar u = Get.put(UserVar());
  final LsVar ls=Get.put(LsVar());

  void errDialog(String title, BuildContext context){
    showOkAlertDialog(
      context: context,
      title: title,
      message: "请检查你的网络连接",
      okLabel: "好的"
    );
  }

  Future<void> getPlayLists(BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getPlaylists?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        errDialog("获取所有歌单失败", context);
      }
      return;
    }else{
      try {
        ls.playList.value=rlt['subsonic-response']['playlists']['playlist'];
      } catch (_) {
        if(context.mounted){
          errDialog("获取所有歌单失败", context);
        }
      }
    }
  }

  Future<List> getAll(BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getRandomSongs?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&size=500");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        errDialog("获取所有歌单失败", context);
      }
      return [];
    }else{
      try {
        var tmpList=rlt['subsonic-response']['randomSongs']['song'];
        tmpList.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a['created']);
          DateTime dateTimeB = DateTime.parse(b['created']);
          return dateTimeB.compareTo(dateTimeA);
        });
        return tmpList;
      } catch (_) {
        if(context.mounted){
          errDialog("获取所有歌单失败", context);
        }
        return [];
      }
    }
  }

  Future<List> getLoved(BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getStarred?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        errDialog("获取所有歌单失败", context);
      }
      return [];
    }else{
      try {
        if(rlt['subsonic-response']['starred']['song']==null){
          // 没有喜欢的歌曲
          return [];
        }else{
          return rlt['subsonic-response']['starred']['song'];
        }
      } catch (_) {
        if(context.mounted){
          errDialog("获取所有歌单失败", context);
        }
        return [];
      }
    }
  }

  Future<List> getPlayList(BuildContext context, String id) async {
    final rlt=await httpRequest("${u.url.value}/rest/getPlaylist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=$id");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        errDialog("获取歌单失败", context);
      }
      return [];
    }else{
      try {
        return rlt["subsonic-response"]["playlist"]['entry'];
      } catch (_) {}
    }
    return [];
  }

}