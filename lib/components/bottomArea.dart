// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, invalid_use_of_protected_member

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/lyricContent.dart';
import 'package:netplayer_mobile/components/operations.dart';
import 'package:netplayer_mobile/para/para.dart';

class BottomArea extends StatefulWidget {

  final ValueChanged changeSize;

  const BottomArea({super.key, required this.changeSize});

  @override
  State<BottomArea> createState() => _BottomAreaState();
}

class _BottomAreaState extends State<BottomArea> {

  final Controller c = Get.put(Controller());

  void changeContent(String type){
    c.updateMenuType(type);
    switch (type) {
      case "lyric":
        widget.changeSize(500.0);
        break;
      case "playMode":
        widget.changeSize(260.0);
        break;
      case "add":
        songAddListController(c.playInfo["id"], context, pop: false);
        widget.changeSize(100.0);
        c.updateMenuType("");
        break;
      case "more":
        widget.changeSize(400.0);
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) async {
                if(details.delta.dy>10){
                  c.updateMenuType("");
                  widget.changeSize(100.0);
                }
              },
              child: Container(
                color: Colors.transparent,
                width: double.infinity,
                height: 60,
              ),
            ),
            Center(
              child: SizedBox(
                height: 60,
                width: 220,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => changeContent("lyric"),
                      child: Obx(() => 
                        Icon(
                          Icons.lyrics,
                          color: c.menuType.value=="lyric" ? c.mainColor : Colors.black,
                        ),
                      )
                    ),
                    GestureDetector(
                      onTap: () {
                        if(!c.fullRandom.value){
                          changeContent("playMode");
                        }
                      },
                      child: Obx(() => 
                        c.fullRandom.value ? Icon(
                          Icons.shuffle_rounded,
                          color: Colors.grey,
                        ) : 
                        c.playMode.value=="随机播放" ? Icon(
                          Icons.shuffle_rounded,
                          color: c.menuType.value=="playMode" ? c.mainColor : Colors.black,
                        ) : 
                        c.playMode.value=="顺序播放" ? Icon(
                          Icons.repeat_rounded,
                          color: c.menuType.value=="playMode" ? c.mainColor : Colors.black,
                        ) :
                        Icon(
                          Icons.repeat_one_rounded,
                          color: c.menuType.value=="playMode" ? c.mainColor : Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => changeContent("add"),
                      child: Obx(() => 
                        Icon(
                          Icons.add_rounded,
                          color: c.menuType.value=="add" ? c.mainColor : Colors.black,
                        )
                      )
                    ),
                    GestureDetector(
                      onTap: () => changeContent("more"),
                      child: Obx(() => 
                        Icon(
                          Icons.more_horiz_rounded,
                          color: c.menuType.value=="more" ? c.mainColor : Colors.black,
                        )
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Stack(
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: lyricContent(height: 400),
            ),
            Obx(() => 
              AnimatedOpacity(
                opacity: c.menuType.value=="playMode" ? 1 : 0,
                duration: Duration(milliseconds: 200),
                child: Center(
                  child: SizedBox(
                    width: 220,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            c.updatePlayMode("顺序播放");
                            c.updateMenuType("");
                            widget.changeSize(100.0);
                          },
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.repeat_rounded,
                                  color: c.playMode.value=="顺序播放" ? c.mainColor : Colors.black,
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "顺序播放",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 16,
                                    color: c.playMode.value=="顺序播放" ? c.mainColor : Colors.black,
                                  ),
                                ),
                                Expanded(child: Container(color: Colors.white,))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            c.updatePlayMode("随机播放");
                            c.updateMenuType("");
                            widget.changeSize(100.0);
                          },
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.shuffle_rounded,
                                  color: c.playMode.value=="随机播放" ? c.mainColor : Colors.black,
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "顺序播放",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 16,
                                    color: c.playMode.value=="随机播放" ? c.mainColor : Colors.black,
                                  ),
                                ),
                                Expanded(child: Container(color: Colors.white,))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            c.updatePlayMode("单曲循环");
                            c.updateMenuType("");
                            widget.changeSize(100.0);
                          },
                          child: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.repeat_one_rounded,
                                  color: c.playMode.value=="单曲循环" ? c.mainColor : Colors.black,
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "顺序播放",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: 16,
                                    color: c.playMode.value=="单曲循环" ? c.mainColor : Colors.black,
                                  ),
                                ),
                                Expanded(child: Container(color: Colors.white,))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ),
            Obx(() => 
              AnimatedOpacity(
                opacity: c.menuType.value=="more" ? 1 : 0,
                duration: Duration(milliseconds: 200),
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${c.playInfo["id"]}",
                                fit: BoxFit.contain,
                                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    "assets/blank.jpg",
                                    fit: BoxFit.contain,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => 
                                  Text(
                                    c.playInfo["title"],
                                    maxLines: 2,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      color: Colors.black,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Noto",
                                    ),
                                  )
                                ),
                                Obx(() => 
                                  Text(
                                    c.playInfo["artist"],
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 17,
                                      decoration: TextDecoration.none,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Noto",
                                    ),
                                  )
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ],
    );
  }
}