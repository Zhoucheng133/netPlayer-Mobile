import 'dart:async';
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

  Future<void> init() async {
    if(r.socket!=null){
      r.isRegister.value=true;
      setState(() {
        isLoading=false;
      });
      return;
    }
    prefs=await SharedPreferences.getInstance();
    final url=prefs.getString('remote');
    if(url!=null && url.startsWith("ws://")){
      try {
        r.socket=await WebSocket.connect(url).timeout(
          const Duration(seconds: 2),
        );
        await r.socket!.close();
        r.isRegister.value=true;
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
  void dispose() {
    super.dispose();
    try {
      r.socket!.close();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: !r.isRegister.value,
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
                  key: const Key("loading"),
                  child: LoadingAnimationWidget.beat(
                    color: Colors.blue, 
                    size: 30
                  ),
                ) : r.isRegister.value ? const RemoteContent(key: Key('content'),) : const RemoteRegister(key: Key('register'),)
              )
            )
          ],
        ),
      )
    );
  }
}