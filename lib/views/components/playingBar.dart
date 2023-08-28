// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class playingBar extends StatefulWidget {
  const playingBar({super.key});

  @override
  State<playingBar> createState() => _playingBarState();
}

class _playingBarState extends State<playingBar> {
  final Controller c = Get.put(Controller());
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10,),
        Container(
          color: Colors.red,
          width: 50,
          height: 50,
        ),
        SizedBox(width: 10,),
        Container(
          constraints: BoxConstraints(
            maxWidth: 160
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => 
                Text(
                  c.playInfo.isEmpty ? 
                  "没有播放" : 
                  c.playInfo["title"] ?? "没有播放",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
              ),
              Obx(() => 
                Text(
                  c.playInfo.isEmpty ? 
                  "/" : 
                  c.playInfo["artist"] ?? "/",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis
                  ),
                )
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
        SizedBox(width: 20,),
        GestureDetector(
          child: Obx(() => 
            c.isPlay.value==false ? 
            Icon(
              Icons.play_arrow_rounded,
              size: 35,
            ) : 
            Icon(
              Icons.pause_rounded,
              size: 35,
            )
          ),
        ),
        SizedBox(width: 10,),
        GestureDetector(
          child: Icon(
            Icons.skip_next_rounded,
            size: 35,
          ),
        ),
        SizedBox(width: 10,),
      ],
    );
  }
}