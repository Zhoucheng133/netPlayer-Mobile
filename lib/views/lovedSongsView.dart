// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, prefer_const_literals_to_create_immutables, invalid_use_of_protected_member, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/operations.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';

class lovedSongsView extends StatefulWidget {
  const lovedSongsView({super.key, required this.audioHandler});

  final dynamic audioHandler;

  @override
  State<lovedSongsView> createState() => _lovedSongsViewState();
}

class _lovedSongsViewState extends State<lovedSongsView> {

  final Controller c = Get.put(Controller());

  List songList=[];

  reloadLoved() async {
    var tmp=await lovedSongRequest();
    c.updateLovedSongs(tmp);
    setState(() {
      songList=tmp;
    });
    if(c.playInfo["name"]=="lovedSongs"){
      widget.audioHandler.stop();
    }
  }

  Future<void> getLovedSongs() async {
    if(c.lovedSongs.isNotEmpty){
      setState(() {
        songList=c.lovedSongs.value;
      });
    }else{
      var tmp=await lovedSongRequest();
      setState(() {
        songList=tmp;
      });
      c.updateLovedSongs(tmp);
    }
  }

  void reloadList(BuildContext context){
    if(Platform.isIOS){
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("确定要刷新列表吗?"),
            content: Text("这可能会停止当前播放的歌曲"),
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
                  var tmp=await lovedSongRequest();
                  setState(() {
                    songList=tmp;
                  });
                  c.updateLovedSongs(tmp);
                  if(c.playInfo["name"]=="lovedSongs"){
                    widget.audioHandler.stop();
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("确定要刷新列表吗?"),
            content: Text("这可能会停止当前播放的歌曲"),
            actions: <Widget>[
              TextButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('确定'),
                onPressed: () async {
                  var tmp=await lovedSongRequest();
                  setState(() {
                    songList=tmp;
                  });
                  c.updateLovedSongs(tmp);
                  if(c.playInfo["name"]=="lovedSongs"){
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
  }

  @override
  void initState() {
    super.initState();

    getLovedSongs();
  }

  final myScrollController=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
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
            controller: myScrollController,
            child: ListView.builder(
              controller: myScrollController,
              itemCount: songList.length,
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  onTap: (){
                    playSong(songList[index], index, "lovedSongs", widget.audioHandler);
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
                                    c.playInfo.isNotEmpty && c.playInfo["name"]=="lovedSongs" && c.playInfo["index"]==index ? 
                                    Icon(
                                      Icons.play_arrow_rounded,
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
                                  c.playInfo.isNotEmpty && c.playInfo["name"]=="lovedSongs" && c.playInfo["index"]==index ? 
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
                                    Expanded(
                                      child: Obx(() => 
                                        c.playInfo.isNotEmpty && c.playInfo["name"]=="lovedSongs" && c.playInfo["index"]==index ? 
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
                                    pageName: "allSongs", 
                                    audioHandler: widget.audioHandler, 
                                    reloadLoved: reloadLoved,
                                    playSong: ()=>playSong(songList[index], index, "lovedSongs", widget.audioHandler)
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
                                      c.playInfo.isNotEmpty && c.playInfo["name"]=="lovedSongs" && c.playInfo["index"]==index ? 
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
    );
  }
}