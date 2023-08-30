// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unrelated_type_equality_checks, invalid_use_of_protected_member, use_build_context_synchronously, camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';

final Controller c = Get.put(Controller());

List pageNameMap(String name, {List? playlist}){
  switch (name) {
    case "allSongs":
      return c.allSongs.value;
    case "lovedSongs":
      return c.lovedSongs.value;
    case "songList" || "album": 
      if(playlist!=null){
        return playlist;
      }else{
        return [];
      }
    default: 
      return [];
  }
}

void playSong(Map item, int index, String pageName, dynamic audioHandler, {String? listID, List? playlist}){
  var newInfo={
    "name": pageName, 
    "title": item["title"],
    "artist": item["artist"],
    "duration": item["duration"],
    "id": item["id"],
    "index": index,
    "list": pageNameMap(pageName, playlist: playlist),
    "ListId": listID ?? "",
    "album": item["album"],
  };
  c.updatePlayInfo(newInfo);
  audioHandler.play();
}

void songRemoveListController(String? index){
  if(index==null){
    return;
  }else{
    // TODO 从歌单中删除
  }
}

void songAddListController(){
  // TODO 添加到某个歌单
}

void songDeloveController(){
  // TODO 从我喜欢中删除
}

Future<void> songLoveController(Map item, BuildContext context) async {
  if(await setLove(item["id"])){
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("操作成功!"),
          content: Text("已经添加到喜欢的歌曲"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }else{
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("操作失败!"),
          content: Text("可以尝试稍后重试"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class moreOperations extends StatefulWidget {
  const moreOperations({super.key, required this.item, required this.index, required this.pageName, required this.audioHandler, this.listIndex, required this.reloadLoved});
  final Map item;
  final int index;
  final String pageName;
  final dynamic audioHandler;
  final dynamic listIndex;

  final VoidCallback reloadLoved;

  @override
  State<moreOperations> createState() => _moreOperationsState();
}

class _moreOperationsState extends State<moreOperations> {
  @override
  Widget build(BuildContext context) {
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
                      "${c.userInfo["url"]}/rest/getCoverArt?v=1.12.0&c=netPlayer&f=json&u=${c.userInfo["username"]}&t=${c.userInfo["token"]}&s=${c.userInfo["salt"]}&id=${widget.item["id"]}",
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
                        widget.item["title"],
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
                      widget.item["artist"],
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
                playSong(widget.item, widget.index, widget.pageName, widget.audioHandler);
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
            widget.item.containsKey("starred") ? 
            GestureDetector(
              onTap: (){
                songDeloveController();
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
                songLoveController(widget.item, context);
                widget.reloadLoved();
                // print("ok");
                Navigator.pop(context);
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
              onTap: (){
                songAddListController();
              },
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
              onTap: (){
                songRemoveListController(widget.listIndex);
              },
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
    );  }
}