import 'dart:io';

import 'package:get/get.dart';

class WsData{
  String title="";
  String cover="";
  int line=0;
  List fullLyric=[];
  bool isPlay=false;
  String mode="";
  String lyric="";

  void updateAll(
    String title,
    String cover,
    int line,
    List fullLyric,
    bool isPlay,
    String mode,
    String lyric,
  ) {
    this.title = title;
    this.cover = cover;
    this.line = line;
    this.fullLyric = fullLyric;
    this.isPlay = isPlay;
    this.mode = mode;
    this.lyric = lyric;
  }
}

class RemoteVar extends GetxController{
  RxString url=''.obs;
  WebSocket? socket;
  RxBool isRegister=false.obs;
  var wsData=WsData().obs;
}