import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    if(p.useNavidrome.value){
      if(u.uniqueId.value.isEmpty || u.authorization.value.isEmpty){
        await getNavidromeAuth();
      }
      if(u.authorization.value.isNotEmpty && u.uniqueId.value.isNotEmpty){
        List tmpList=await getAllSongByNavidrome();
        if(tmpList.isNotEmpty){
          tmpList.sort((a, b) {
            DateTime dateTimeA = DateTime.parse(a['createdAt']??a['created']);
            DateTime dateTimeB = DateTime.parse(b['createdAt']??b['created']);
            return dateTimeB.compareTo(dateTimeA);
          });
          return tmpList;
        }
      }
    }

    final rlt=await httpRequest("${u.url.value}/rest/getRandomSongs?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&size=500");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取所有歌曲失败", "请检查你的网络连接", context);
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
          dialog("获取所有歌曲失败","请检查你的网络连接", context);
        }
        return [];
      }
    }
  }

  // Navidrome获取用户验证信息
  Future<bool> getNavidromeAuth() async {
    if(u.password.value.isEmpty){
      return false;
    }
    try {
      final response=await http.post(
        Uri.parse('${u.url.value}/auth/login'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": u.username.value,
          "password": u.password.value,
        }),
      );
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> data = json.decode(responseBody);
      if(data['token'].isNotEmpty && data['id'].isNotEmpty){
        u.authorization.value="Bearer ${data['token']}";
        u.uniqueId.value=data['id'];
        return true;
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  Future<List> getAllSongByNavidrome() async {
    try {
      final response=await http.get(
        Uri.parse('${u.url.value}/api/song'),
        headers: {
          "x-nd-authorization": u.authorization.value,
          "x-nd-client-unique-id": u.uniqueId.value,
        },
      );
      String responseBody = utf8.decode(response.bodyBytes);
      List ls = json.decode(responseBody) as List;
      if(p.removeMissing.value){
        ls=ls.where((item){
          return item['missing']!=true;
        }).toList();
      }
      ls=ls.map((item){
        if (item['duration'] is num) {
          item['duration'] = (item['duration'] as num).toInt();
        }
        if (item.containsKey('createdAt')) {
          item['created'] = item['createdAt'];
          item.remove('createdAt');
        }
        return item;
      }).toList();
      return ls;
    } catch (_) {
      return [];
    }
  }

  Future<List> getAlbumsByNavidrome() async {
    try {
      final response=await http.get(
        Uri.parse('${u.url.value}/api/album'),
        headers: {
          "x-nd-authorization": u.authorization.value,
          "x-nd-client-unique-id": u.uniqueId.value,
        },
      );
      String responseBody = utf8.decode(response.bodyBytes);
      List ls = json.decode(responseBody) as List;
      if(p.removeMissing.value){
        ls=ls.where((item){
          return item['missing']!=true;
        }).toList();
      }
      ls=ls.map((item){
        if (item['duration'] is num) {
          item['duration'] = (item['duration'] as num).toInt();
        }
        if (item.containsKey('createdAt')) {
          item['created'] = item['createdAt'];
          item.remove('createdAt');
        }
        if (item.containsKey('name')) {
          item['title'] = item['name'];
          item.remove('name');
        }
        if (item.containsKey('albumArtist')) {
          item['artist'] = item['albumArtist'];
          item.remove('albumArtist');
        }
        if (item.containsKey('albumArtistId')) {
          item['artistId'] = item['albumArtistId'];
          item.remove('albumArtistId');
        }
        if (item.containsKey('maxYear')) {
          item['year'] = item['maxYear'];
          item.remove('maxYear');
        }
        return item;
      }).toList();
      return ls;
    } catch (_) {
      return [];
    }
  }

  Future<List> getLoved(BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getStarred?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dialog("获取喜欢的歌曲","请检查你的网络连接", context);
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
          dialog("获取喜欢的歌曲", "请检查你的网络连接", context);
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

    if(p.useNavidrome.value){
      if(u.uniqueId.value.isEmpty || u.authorization.value.isEmpty){
        await getNavidromeAuth();
      }
      if(u.authorization.value.isNotEmpty && u.uniqueId.value.isNotEmpty){
        List tmpList=await getAlbumsByNavidrome();
        if(tmpList.isNotEmpty){
          return tmpList;
        }
      }
    }

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
        return rlt['subsonic-response']['album']['song'];
      } catch (_) {}
      return [];
    }
  }

  Future<Map> getAlbumInfo(String id, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/getAlbum?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&id=$id");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      return {};
    }else{
      try {
        return rlt['subsonic-response']['album'];
      } catch (_) {}
      return {};
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
}