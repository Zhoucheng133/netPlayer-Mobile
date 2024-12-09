import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
      r.wsData.value.updateAll(msg['title'], msg['artist'], msg['cover'], msg['line'], msg['fullLyric'],  msg['isPlay'], msg['mode'], msg['lyric']);
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: r.wsData.value.cover.startsWith("http") ? Image.network(r.wsData.value.cover, width: 70,) : Image.asset('assets/blank.jpg', width: 70,)
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.wsData.value.title,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        r.wsData.value.artist,
                        style: GoogleFonts.notoSansSc(
                          color: Colors.grey[500]
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ]
            ),
          )
        ],
      )
    );
  }
}