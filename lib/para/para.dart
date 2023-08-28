// ignore_for_file: non_constant_identifier_names

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
  // 所有歌手信息
  var artists=[].obs;
  // 所有专辑信息
  var albums=[].obs;
  // 当前页面
  var pageIndex=0.obs;

  // 主题色
  var mainColor=const Color.fromARGB(255, 24, 144, 255);
  // 强调色
  var mainColorStrang=const Color.fromARGB(255, 0, 100, 194);
  // 页面索引关系
  var pageAsyc={
    0: "所有音乐",
    1: "我喜欢的",
    2: "歌单",
    3: "艺人",
    4: "关于",
    5: "播放器",
  };
  // 版本号
  var version="1.0.0".obs;

  // 当前播放歌曲信息规则
  var playInfo_example={
    "name": "allSongs",     // 其它参数: lovedSongs, songList, album
    "id": "songID",         // 歌曲id号
    "title": "songTitle",   // 歌曲标题
    "artist": "ryan",       // 艺人
    "duration": 1234,       // 歌曲长度(秒)
    "ListId": "abc123",     // 当listName为songList或者album的时候需要此参数
    "index": 1,             // 播放到哪个了
    "list": [],             // 播放列表
  };

  // 更新数据
  void updateLogin(data) => isLogin.value=data;
  void updateUserInfo(data) => userInfo.value=data;
  void updateIsPlay(data) => isPlay.value=data;
  void updatePlayInfo(Map data) => playInfo.value=data;
  void updateAllSongs(data) => allSongs.value=data;
  void updateArtists(data) => artists.value=data;
  void upateAlbums(data) => albums.value=data;
  void updatePageIndex(data) => pageIndex.value=data;
}