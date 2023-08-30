// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unrelated_type_equality_checks, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';

final Controller c = Get.put(Controller());

void playSong(Map item, int index, dynamic audioHandler){
  var newInfo={
    "name": "allSongs", 
    "title": item["title"],
    "artist": item["artist"],
    "duration": item["duration"],
    "id": item["id"],
    "index": index,
    "list": c.allSongs.value,
    "album": item["album"],
  };
  c.updatePlayInfo(newInfo);
  audioHandler.play();
}

void moreOperations(BuildContext context, Map item, int index, dynamic audioHandler){
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          ),
          color: Colors.white
        ),
        // height: 200,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: Obx(() => 
                      Image.network(
                        "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${item["id"]}",
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
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width-40-110,
                        child: Text(
                          item["title"],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        item["artist"],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  playSong(item, index, audioHandler);
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        size: 30,
                      ),
                      SizedBox(width: 17,),
                      Text(
                        "播放",
                        style: TextStyle(
                          fontSize: 17
                        ),
                      )
                    ],
                  ),
                ),
              ),
              item.containsKey("starred") ? 
              GestureDetector(
                onTap: (){
                  // TODO 从我喜欢中删除
                },
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.heart_broken,
                        size: 30,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 17,),
                      Text(
                        "从\"我喜欢的\"中删除",
                        style: TextStyle(
                          fontSize: 17
                        ),
                      )
                    ],
                  ),
                ),
              ) :
              GestureDetector(
                onTap: (){
                  // TODO 添加到喜欢
                },
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.favorite,
                        size: 30,
                        color: Colors.red,
                      ),
                      SizedBox(width: 17,),
                      Text(
                        "添加到到\"我喜欢的\"",
                        style: TextStyle(
                          fontSize: 17
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.playlist_add,
                        size: 30,
                        color: Colors.black,
                      ),
                      SizedBox(width: 17,),
                      Text(
                        "加入到歌单...",
                        style: TextStyle(
                          fontSize: 17
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() => 
                        Icon(
                          Icons.playlist_remove,
                          size: 30,
                          color: c.pageIndex==2 ? Colors.black : Colors.grey,
                        )
                      ),
                      SizedBox(width: 17,),
                      Obx(() => 
                        Text(
                          "从歌单中删除",
                          style: TextStyle(
                            fontSize: 17,
                            color: c.pageIndex==2 ? Colors.black : Colors.grey,
                          ),
                        )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      );
    },
  );
}