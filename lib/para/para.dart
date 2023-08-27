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

  void updateLogin(data) => isLogin.value=data;
  void updateUserInfo(data) => userInfo.value=data;
  void updateIsPlay(data) => isPlay.value=data;
  void updatePlayInfo(data) => playInfo.value=data;
  void updateAllSongs(data) => allSongs.value=data;
  void updateArtists(data) => artists.value=data;
  void upateAlbums(data) => albums.value=data;
  void updatePageIndex(data) => pageIndex.value=data;
}