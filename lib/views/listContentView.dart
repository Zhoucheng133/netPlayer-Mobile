// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/operations.dart';
import 'package:netplayer_mobile/components/playingBar.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';

class listContentView extends StatefulWidget {
  const listContentView({super.key, required this.audioHandler, required this.item});

  final Map item;
  final dynamic audioHandler;

  @override
  State<listContentView> createState() => _listContentViewState();
}

class _listContentViewState extends State<listContentView> {
  final Controller c = Get.put(Controller());

  Future<void> forceReload() async {
    List tmp=await getListContent(widget.item["id"]);
    if(tmp.isNotEmpty){
      setState(() {
        songList=tmp;
      });
    }
    if(c.playInfo["name"]=="songList" && c.playInfo["ListId"]==widget.item["id"]){
      widget.audioHandler.stop();
    }
  }

  Future<void> reloadList(BuildContext context)async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("确定要刷新歌曲列表吗?"),
          content: Text("这可能会停止当前播放"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('确定'),
              onPressed: () async {
                List tmp=await getListContent(widget.item["id"]);
                if(tmp.isNotEmpty){
                  setState(() {
                    songList=tmp;
                  });
                }
                if(c.playInfo["name"]=="songList" && c.playInfo["ListId"]==widget.item["id"]){
                  widget.audioHandler.stop();
                }
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  var songList=[];

  Future<void> getList() async {
    List tmp=await getListContent(widget.item["id"]);
    if(tmp.isNotEmpty){
      setState(() {
        songList=tmp;
      });
    }
  }

  reloadLoved() async {
    var tmp=await lovedSongRequest();
    c.updateLovedSongs(tmp);

    if(c.playInfo["name"]=="lovedSongs"){
      widget.audioHandler.stop();
    }
  }

  Future<void> getLovedSongs() async {
    if(c.lovedSongs.isEmpty){
      var tmp=await lovedSongRequest();
      c.updateLovedSongs(tmp);
    }
  }

  @override
  void initState() {
    super.initState();
    getList();
    getLovedSongs();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.item["name"]),
        backgroundColor: Colors.white,
        foregroundColor: c.mainColor,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                color: Colors.white,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "合计${songList.length}首歌", 
                        style: TextStyle(color: c.mainColor),
                      ),
                      SizedBox(width: 8,),
                      GestureDetector(
                        onTap: (){
                          reloadList(context);
                        },
                        child: Icon(
                          Icons.refresh,
                          color: c.mainColor,
                        ),
                      )
                    ],
                  )
                ),
              ),
              Expanded(
                child: CupertinoScrollbar(
                  child: ListView.builder(
                    itemCount: songList.length,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                        onTap: (){
                          playSong(songList[index], index, "songList", widget.audioHandler, listID: widget.item["id"], playlist: songList);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,10,0),
                          child: Container(
                            height: 60,
                            color: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Obx(() => 
                                          c.playInfo.isNotEmpty && c.playInfo["name"]=="songList" && c.playInfo["index"]==index && c.playInfo["ListId"]==widget.item["id"] ? 
                                          Icon(
                                            Icons.play_arrow,
                                            color: c.mainColor,
                                          ) : 
                                          Text(
                                            (index+1).toString(),
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          )
                                        ),
                                        SizedBox(width: 5,)
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(() =>
                                        c.playInfo.isNotEmpty && c.playInfo["name"]=="songList" && c.playInfo["index"]==index && c.playInfo["ListId"]==widget.item["id"] ? 
                                        Text(
                                          songList[index]["title"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: c.mainColor
                                          ),
                                        ) : 
                                        Text(
                                          songList[index]["title"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                          ),
                                        )
                                      ),
                                      Row(
                                        children: [
                                          Obx(() => 
                                            c.fav(songList[index]["id"])==false ? 
                                            Container() : 
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.favorite,
                                                  size: 15,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 5,)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Obx(() => 
                                              c.playInfo.isNotEmpty && c.playInfo["name"]=="songList" && c.playInfo["index"]==index && c.playInfo["ListId"]==widget.item["id"] ? 
                                              Text(
                                                songList[index]["artist"],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: c.mainColor
                                                )
                                              ) : 
                                              Text(
                                                songList[index]["artist"],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey
                                                )
                                              )
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet<void>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return moreOperations(
                                          item: songList[index], 
                                          index: index, 
                                          pageName: "songList", 
                                          audioHandler: widget.audioHandler,
                                          reloadLoved: reloadLoved,
                                          listId: widget.item["id"],
                                          reloadList: forceReload,
                                          playSong: ()=>playSong(songList[index], index, "songList", widget.audioHandler, listID: widget.item["id"], playlist: songList),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    width: 50,
                                    height: double.infinity,
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(width: 10,),
                                          Obx(() => 
                                            c.playInfo.isNotEmpty && c.playInfo["name"]=="songList" && c.playInfo["index"]==index && c.playInfo["ListId"]==widget.item["id"] ? 
                                            Icon(
                                              Icons.more_vert,
                                              size: 20,
                                              color: c.mainColor,
                                            ) : 
                                            Icon(
                                              Icons.more_vert,
                                              size: 20,
                                            )
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ), 
              SizedBox(height: 70,)
            ],
          ),
          Positioned(
            bottom: 0,
            height: 110,
            child: Column(
              children: [
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 250, 250),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, -3), // 在顶部添加阴影偏移
                      ),
                    ],
                  ),
                  // color: Colors.white,
                  child: playingBar(audioHandler: widget.audioHandler,),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  color: Color.fromARGB(255, 250, 250, 250),
                )
              ],
            )
          )
        ]
      ),
    );
  }
}