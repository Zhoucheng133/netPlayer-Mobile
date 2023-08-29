// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

class playingView extends StatefulWidget {
  const playingView({super.key, required this.audioHandler});

  final dynamic audioHandler;

  @override
  State<playingView> createState() => _playingViewState();
}

class _playingViewState extends State<playingView> {
  final Controller c = Get.put(Controller());

  void playController(){
    if(c.isPlay.value==true){
      widget.audioHandler.pause();
    }else{
      widget.audioHandler.play();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (details){
            if(details.delta.dy>10){
                Navigator.pop(context);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 250, 250, 250),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.swipe_down_alt,
                        size: 40,
                      ),
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "向下滑动返回",
                    ),
                  ],
                ),
                SizedBox(height: 40,),
                Hero(
                  tag: "cover",
                  child: AnimatedContainer(
                    width: MediaQuery.of(context).size.width-120,
                    height: MediaQuery.of(context).size.width-120,
                    color: Colors.white,
                    duration: Duration(milliseconds: 200),
                    child: Obx(() => 
                      c.playInfo["id"]==null ?
                      Image.asset(
                        "assets/blank.jpg",
                        fit: BoxFit.contain,
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
                ),
                Container(
                  height: 140,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                        child: Obx(() => 
                          Text(
                            c.playInfo["title"]==null ? "没有播放" : c.playInfo["title"].toString(),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                        child: Obx(() => 
                          Text(
                            c.playInfo["title"]==null ? "/" : c.playInfo["artist"].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        widget.audioHandler.skipToPrevious();
                      },
                      child: Icon(
                        Icons.skip_previous_rounded,
                        size: 65,
                      ),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        playController();
                      },
                      child: Obx(() => 
                        c.isPlay==true ? 
                        Icon(
                          Icons.pause_rounded,
                          size: 70,
                        ):
                        Icon(
                          Icons.play_arrow_rounded,
                          size: 70,
                        )
                      )
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        widget.audioHandler.skipToNext();
                      },
                      child: Icon(
                        Icons.skip_next_rounded,
                        size: 65,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}