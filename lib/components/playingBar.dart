// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class playingBar extends StatefulWidget {
  const playingBar({super.key, required this.audioHandler});
  final dynamic audioHandler;

  @override
  State<playingBar> createState() => _playingBarState();
}

class _playingBarState extends State<playingBar> {
  final Controller c = Get.put(Controller());

  void playController(){
    if(c.playInfo["id"]==null){
      return;
    }
    if(c.isPlay.value==true){
      widget.audioHandler.pause();
    }else{
      widget.audioHandler.play();
    }
  }

  void skipController(){
    if(c.playInfo["id"]==null){
      return;
    }

    widget.audioHandler.skipToNext();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details){
        if(details.delta.dy<-10){
          c.updatePageIndex(5);
        }
      },
      onTap: (){
        c.updatePrePageIndex(c.pageIndex.value);
        c.updatePageIndex(5);
      },
      child: Container(
        color: Color.fromARGB(255, 250, 250, 250),
        child: Row(
          children: [
            SizedBox(width: 10,),
            Container(
              color: Colors.white,
              width: 50,
              height: 50,
              child: Obx(() => 
                c.playInfo["id"]==null ?
                Hero(
                  tag: "cover",
                  child: Image.asset(
                    "assets/blank.jpg",
                    fit: BoxFit.contain,
                  ),
                ) : 
                Image.network(
                  "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}",
                  fit: BoxFit.contain,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      "assets/blank.jpg",
                      fit: BoxFit.contain,
                    );
                  },
                )
              ),
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
                      c.playInfo["title"]==null ? "没有播放" : c.playInfo["title"].toString(),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ),
                  Obx(() => 
                    Text(
                      c.playInfo["title"]==null ? "/" : c.playInfo["artist"].toString(),
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
              onTap: (){
                playController();
              },
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
              onTap: (){
                skipController();
              },
              child: Icon(
                Icons.skip_next_rounded,
                size: 35,
              ),
            ),
            SizedBox(width: 10,),
          ],
        ),
      ),
    );
  }
}