import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' show decodeImage;
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:http/http.dart' as http;

class DataGet{

  final UserVar u = Get.find();
  final LsVar ls=Get.find();
  final PlayerVar p=Get.find();
  final DialogVar d=Get.find();

  void dialog(String title, String msg, BuildContext context){
    d.showOkDialog(
      context: context, 
      title: title, 
      content: msg,
      okText: '好的'
    );
  }

  Future<void> getPlayLists(BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getPlaylists?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取所有歌单失败", "请检查你的网络连接", context);
      }
      return;
    }else{
      try {
        if(rlt['subsonic-response']['playlists'].isEmpty){
          ls.playList.value=[];
        }else{
          ls.playList.value=rlt['subsonic-response']['playlists']['playlist'];
        }
      } catch (_) {
        if(context.mounted){
          dialog("获取所有歌单失败", "请检查你的网络连接", context);
        }
      }
    }
  }

  Future<List> getAll(BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getRandomSongs?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&size=500");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取所有歌单失败", "请检查你的网络连接", context);
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
          dialog("获取所有歌单失败","请检查你的网络连接", context);
        }
        return [];
      }
    }
  }

  Future<List> getLoved(BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getStarred?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取所有歌单失败","请检查你的网络连接", context);
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
          dialog("获取所有歌单失败", "请检查你的网络连接", context);
        }
        return [];
      }
    }
  }

  Future<List> getPlayList(BuildContext context, String id) async {
    final rlt=await httpRequest("${u.url.value}/rest/getPlaylist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=$id");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取歌单失败", "请检查你的网络连接", context);
      }
      return [];
    }else{
      try {
        return rlt["subsonic-response"]["playlist"]['entry'];
      } catch (_) {}
    }
    return [];
  }

  Future<List> getArtists(BuildContext context) async {
    final rlt=await httpRequest('${u.url.value}/rest/getArtists?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}');
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取所有艺人失败", "请检查你的网络连接", context);
      }
      return [];
    }else{
      try {
        var list=[];
        var tmp=rlt['subsonic-response']["artists"]["index"].map((item) => item['artist']).toList();
        for(var i=0;i<tmp.length;i++){
          for(var j=0;j<tmp[i].length;j++){
            list.add(tmp[i][j]);
          }
        }
        return list;
      } catch (_) {}
    }
    return [];
  }

  Future<List> getAlbums(BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getAlbumList?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&type=newest&size=500");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取所有专辑失败", "请检查你的网络连接", context);
      }
      return [];
    }else{
      try {
        if(rlt['subsonic-response']['albumList']['album']==null){
          return [];
        }else{
          return rlt['subsonic-response']['albumList']['album'];
        }
      } catch (_) {
        if(context.mounted){
          dialog("解析所有专辑失败", "请检查你的网络连接", context);
        }
        return [];
      }
    }
  }

  Future<List> getArtist(String id, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getArtist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=$id");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取艺人信息失败", "请检查你的网络连接", context);
      }
      return [];
    }else{
      try {
        return rlt['subsonic-response']['artist']['album'];
      } catch (_) {}
      return [];
    }
  }

  Future<List> getAlbum(String id, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getAlbum?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=$id");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取专辑信息失败", "请检查你的网络连接", context);
      }
      return [];
    }else{
      try {
        // print(rlt['subsonic-response']['album']);
        return rlt['subsonic-response']['album']['song'];
      } catch (_) {}
      return [];
    }
  }

  Future<Map> getSong(String id, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getSong?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=$id");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取专辑信息失败", "请检查你的网络连接", context);
      }
      return {};
    }else{
      try {
        return rlt['subsonic-response']['song'];
      } catch (_) {}
      return {};
    }
  }

  Future<Uint8List?> fetchCover() async {
    // print("fetch!");
    if(p.nowPlay["id"]=="" || u.username.value.isEmpty){
      return null;
    }
    try {
      // 获取文件流
      var response = await http.get(Uri.parse("${u.url.value}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=${p.nowPlay["id"]}")).timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        return decodeImage(response.bodyBytes)==null ? null:response.bodyBytes;
      } else {
        return null;
      }
    } on TimeoutException {
      return null;
    } catch (e) {
      return null;
    }
  }
}