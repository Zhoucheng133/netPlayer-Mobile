// ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:netplayer_mobile/functions/requests.dart';

class Controller extends GetxController{
  // 是否已经登录了
  var isLogin=false.obs;
  // 用户信息
  var userInfo={}.obs;
  // 是否正在播放
  var isPlay=false.obs;
  // 当前播放歌曲信息
  var playInfo={}.obs;
  // 所有歌曲信息
  var allSongs=[].obs;
  // 搜索结果信息
  var searchRlt=[].obs;
  // 当前页面
  var pageIndex=0.obs;
  // 喜欢的歌曲信息
  var lovedSongs=[].obs;
  // 是否随机播放
  var randomPlay=false.obs;
  // 是否完全随机播放
  var fullRandom=false.obs;
  // 所有歌单
  var playLists=[].obs;
  // 搜索关键词
  var searchKey="".obs;
  // 主题色
  var mainColor=const Color.fromARGB(255, 24, 144, 255);
  // 强调色
  var mainColorStrang=const Color.fromARGB(255, 0, 100, 194);
  // 页面索引关系
  var pageAsyc={
    0: "所有音乐",
    1: "我喜欢的",
    2: "歌单",
    3: "搜索",
    4: "设置",
    5: "播放器",
  };
  var pageAsycEn={
    0: "allSongs",
    1: "lovedSongs",
    2: "songList",
    3: "search",
    4: "settings",
    5: "player",
  };
  // 现在的进度条位置
  var nowDuration=0.obs;

  // 现在的进度条位置(毫秒)
  var nowDurationInMc=0.obs;

  // 当前歌词到第几行了
  var lyricLine=0.obs;
  
  // 歌词
  var lyric=[].obs;

  // ————分割线(上面为所有的全局变量)—————

  // 保存上次的播放
  var savePlay=true.obs;
  // 自动登录
  var autoLogin=true.obs;

  // ————分割线(上面为设置参数)—————

  // 当前播放歌曲信息规则
  var playInfo_example={
    "name": "allSongs",     // 其它参数: lovedSongs, songList, album
    "id": "songID",         // 歌曲id号
    "title": "songTitle",   // 歌曲标题
    "artist": "ryan",       // 艺人
    "duration": 1234,       // 歌曲长度(秒)
    "ListId": "abc123",     // 当listName为songList或者search的时候需要此参数, 如果是search的时候，id为搜索内容
    "index": 1,             // 播放到哪个了
    "list": [],             // 播放列表
    "album": "albumName"    // 专辑名称
  };

  // ————分割线(下面为功能函数)—————

  // 将时间戳转换成毫秒
  int timeToMilliseconds(timeString) {
    List<String> parts = timeString.split(':');
    int minutes = int.parse(parts[0]);
    List<String> secondsParts = parts[1].split('.');
    int seconds = int.parse(secondsParts[0]);
    int milliseconds = int.parse(secondsParts[1]);

    // 将分钟、秒和毫秒转换为总毫秒数
    return (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;
  }

  // ————分割线(下面为更新变量函数)—————
  
  // 更新数据
  void updateLyricLine(data) => lyricLine.value=data;
  void updateLogin(data) => isLogin.value=data;
  void updateUserInfo(data) => userInfo.value=data;
  void updateIsPlay(data) => isPlay.value=data;
  Future<void> updatePlayInfo(Map data) async {
    lyric.value=[
      {
        'time': 0,
        'content': '正在查找歌词...',
      }
    ];
    // print(lyric.value);
    playInfo.value=data;
    String lyricPain=await getLyric(data['title'], data['album'], data['artist'], data['duration'].toString());

    // print(lyricPain);

    if(lyricPain=='没有找到歌词'){
      // print("没有找到歌词");
      lyric.value=[
        {
          'time': 0,
          'content': '没有找到歌词',
        }
      ];
      return;
    }

    List lyricCovert=[];
    List<String> lines = LineSplitter.split(lyricPain).toList();
    for(String line in lines){
      int pos1=line.indexOf("[");
      int pos2=line.indexOf("]");
      lyricCovert.add({
        'time': timeToMilliseconds(line.substring(pos1+1, pos2)),
        'content': line.substring(pos2 + 1).trim(),
      });
    }
    lyric.value=lyricCovert;
    // print(lyric.value);
  }
  void updateAllSongs(data) => allSongs.value=data;
  void updatesearchRlt(data) => searchRlt.value=data;
  void updatePageIndex(data) => pageIndex.value=data;
  void updateLovedSongs(data) => lovedSongs.value=data;
  void updateRandomPlay(data) => randomPlay.value=data;
  void updatePlayLists(data) => playLists.value=data;
  void updateSearchKey(data) => searchKey.value=data;
  void updateNowDuration(data) => nowDuration.value=data;
  void updateFullRandom(data) => fullRandom.value=data;
  void updateNowDurationInMc(data){
    nowDurationInMc.value=data;
    if(lyric.isNotEmpty && lyric.length!=1){
      for (var i = 0; i < lyric.length; i++) {
        if(i==lyric.length-1){
          updateLyricLine(0);
          break;
        }else if(data>=lyric[i]['time'] && data<lyric[i+1]['time']){
          updateLyricLine(i+1);
          break;
        }
      }
    }
    // print(lyricLine.toString());
  }

  // 是否标记为喜爱?
  bool fav(String targetId){
    if(lovedSongs.value.isEmpty){
      return false;
    }else{
      for (var map in lovedSongs.value) {
        if (map['id'] == targetId) {
          return true;
        }
      }
    }
    return false;
  }
}