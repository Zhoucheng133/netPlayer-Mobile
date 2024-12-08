import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/pages/components/remote_content.dart';
import 'package:netplayer_mobile/pages/components/remote_register.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:netplayer_mobile/variables/remote_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Remote extends StatefulWidget {
  const Remote({super.key});

  @override
  State<Remote> createState() => _RemoteState();
}

class _RemoteState extends State<Remote> {

  bool isLoading=true;
  late SharedPreferences prefs;
  final r=Get.put(RemoteVar());
  bool isRegister=false;

  Future<void> init() async {
    prefs=await SharedPreferences.getInstance();
    final url=prefs.getString('remote');
    // const url="ws://192.168.123.123";
    if(url!=null && url.startsWith("ws://")){
      try {
        r.socket=await WebSocket.connect(url).timeout(
          const Duration(seconds: 2),
          onTimeout: (){
            throw TimeoutException('timeout');
          }
        );
        final command=json.encode({
          "command": 'get',
        });
        setState(() {
          isRegister=true;
        });
        r.socket!.add(command);
        r.socket!.listen((message) {
          final msg=json.decode(message);
          print(msg);
        });
      } catch (_) {
        r.socket=null;
      }
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        centerTitle: false,
      ),
      body: Column(
        children: [
          const TitleAria(title: '远程控制', subtitle: '',),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading ? Center(
                child: LoadingAnimationWidget.beat(
                  color: Colors.blue, 
                  size: 30
                ),
              ) : isRegister ? const RemoteContent() : const RemoteRegister()
            )
          )
        ],
      ),
    );
  }
}