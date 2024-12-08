import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/remote_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteContent extends StatefulWidget {
  const RemoteContent({super.key});

  @override
  State<RemoteContent> createState() => _RemoteContentState();
}

class _RemoteContentState extends State<RemoteContent> {

  final RemoteVar r=Get.find();
  late SharedPreferences prefs;

  void listener(){
    final command=json.encode({
      "command": 'get',
    });
    r.socket!.add(command);
    r.socket!.listen((message){
      final msg=json.decode(message);
      r.wsData.value.updateAll(msg['title'], msg['cover'], msg['line'], msg['fullLyric'],  msg['isPlay'], msg['mode'], msg['lyric']);
      r.wsData.refresh();
      // print("update!");
    });
  }

  Future<void> init() async {
    prefs=await SharedPreferences.getInstance();
    final url=prefs.getString('remote');
    if(url!=null && url.startsWith("ws://")){
      try {
        r.socket=await WebSocket.connect(url).timeout(
          const Duration(seconds: 2),
        );
        listener();
      } catch (_) {
        r.isRegister.value=false;
        r.socket=null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Column(
        children: [
          Text("标题: ${r.wsData.value.title}"),
          Text("行数: ${r.wsData.value.line.toString()}"),
          Text("播放: ${r.wsData.value.isPlay.toString()}"),
          Text("歌词: ${r.wsData.value.lyric}"),
        ],
      )
    );
  }
}