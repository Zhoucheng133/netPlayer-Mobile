// ignore_for_file: non_constant_identifier_names, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    4: "关于",
    5: "播放器",
  };

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

  // 更新数据
  void updateLogin(data) => isLogin.value=data;
  void updateUserInfo(data) => userInfo.value=data;
  void updateIsPlay(data) => isPlay.value=data;
  void updatePlayInfo(Map data) => playInfo.value=data;
  void updateAllSongs(data) => allSongs.value=data;
  void updatesearchRlt(data) => searchRlt.value=data;
  void updatePageIndex(data) => pageIndex.value=data;
  void updateLovedSongs(data) => lovedSongs.value=data;
  void updateRandomPlay(data) => randomPlay.value=data;
  void updatePlayLists(data) => playLists.value=data;
  void updateSearchKey(data) => searchKey.value=data;

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