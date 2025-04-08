import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/operations/lyric_get.dart';
import 'package:netplayer_mobile/operations/play_check.dart';
import 'package:netplayer_mobile/operations/requests.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Operations{

  DataGet dataGet=DataGet();
  UserVar u = Get.find();
  LsVar l=Get.find();
  PlayerVar p=Get.find();
  LyricGet lyricGet=LyricGet();

  Future<void> renamePlayList(String id, String newname, BuildContext context) async {
    final rlt=await httpRequest("${u.url.value}/rest/updatePlaylist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&playlistId=$id&name=$newname");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.dialog('重命名歌单失败', "请检查你的网络连接", context);
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
        dataGet.dialog('删除歌单失败', "请检查你的网络连接", context);
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
      dataGet.dialog('创建歌单失败', '歌单名称不能为空', context);
      return;
    }
    final rlt=await httpRequest("${u.url.value}/rest/createPlaylist?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&name=$name");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.dialog('创建歌单失败', "请检查你的网络连接", context);
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
        dataGet.dialog('喜欢歌曲失败', "请检查你的网络连接", context);
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
        dataGet.dialog('取消喜欢歌曲失败', "请检查你的网络连接", context);
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
        dataGet.dialog('添加到歌单失败', "请检查你的网络连接", context);
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
        dataGet.dialog('从歌单中删除失败', "请检查你的网络连接", context);
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

  Future<void> getLyric() async {
    lyricGet.getLyric();
  }

  Future<Map> search(String val, BuildContext context) async {
    final rlt= await httpRequest("${u.url.value}/rest/search2?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&query=$val");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.dialog('搜索失败', "请检查你的网络连接", context);
      }
      return {};
    }else{
      try {
        return {
          "songs": rlt["subsonic-response"]["searchResult2"]["song"]??[],
          "albums": rlt["subsonic-response"]["searchResult2"]["album"]??[],
          "artists": rlt["subsonic-response"]["searchResult2"]["artist"]??[]
        };
      } catch (_) {}
      return {};
    }
  }

  Future<void> refreshLibrary(BuildContext context) async {
    final rlt= await httpRequest("${u.url.value}/rest/startScan?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}");
    if(rlt.isEmpty || rlt['subsonic-response']['status']!='ok'){
      if(context.mounted){
        dataGet.dialog('更新失败', "请检查你的网络连接", context);
      }
      return;
    }
    Completer<void> completer = Completer<void>();
    late Timer timer;
    final url="${u.url.value}/rest/getScanStatus?v=1.12.0&c=netPlayer&f=json&u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}";
    timer = Timer.periodic(const Duration(milliseconds: 300), (t) async {
      final status= await httpRequest(url);
      if(status.isEmpty || rlt['subsonic-response']['status']!='ok' || rlt['subsonic-response']['scanStatus']['scanning']==false){
        timer.cancel();
        completer.complete();
      }
    });
    if(context.mounted){
      dataGet.dialog('扫描完成', "已经扫描了全部的音乐库文件", context);
      Future.delayed(const Duration(milliseconds: 200), (){
        if(context.mounted){
          PlayCheck().check(context);
        }
      });
    }
    
  }

  Future<void> resizeFont(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if(context.mounted){
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: MediaQuery.of(context).padding.bottom+160,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){
                      if(p.fontSize.value>10){
                        p.fontSize.value-=1;
                        prefs.setInt('fontSize', p.fontSize.value);
                      }
                    }, 
                    iconSize: 30,
                    icon: const Icon(Icons.remove_rounded)
                  ),
                  const SizedBox(width: 20,),
                  Obx(()=>
                    Text(
                      p.fontSize.toString(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  IconButton(
                    onPressed: (){
                      if(p.fontSize.value<25){
                        p.fontSize.value+=1;
                        prefs.setInt('fontSize', p.fontSize.value);
                      }
                    }, 
                    iconSize: 30,
                    icon: const Icon(Icons.add_rounded)
                  ),
                ],
              ),
            )
          );
        },
      );
    }
  }
}