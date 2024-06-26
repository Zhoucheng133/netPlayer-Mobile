// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, prefer_const_literals_to_create_immutables, invalid_use_of_protected_member, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/listHeader.dart';
import 'package:netplayer_mobile/components/operations.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class lovedSongsView extends StatefulWidget {
  const lovedSongsView({super.key, required this.audioHandler});

  final dynamic audioHandler;

  @override
  State<lovedSongsView> createState() => _lovedSongsViewState();
}

class _lovedSongsViewState extends State<lovedSongsView> {

  final Controller c = Get.put(Controller());

  // List songList=[];

  Future<void> getLovedSongs() async {
    if(c.lovedSongs.isNotEmpty){
      // setState(() {
      //   songList=c.lovedSongs.value;
      // });
    }else{
      var tmp=await lovedSongRequest();
      // setState(() {
      //   songList=tmp;
      // });
      c.updateLovedSongs(tmp);
    }
  }

  Future<void> reloadHandler() async {
    var tmp=await lovedSongRequest();
    // setState(() {
    //   songList=tmp;
    // });
    c.updateLovedSongs(tmp);

    if(c.playInfo["name"]=="lovedSongs"){
      int index = c.lovedSongs.indexWhere((element) => element["id"] == c.playInfo["id"]);
      if(index==-1){
        widget.audioHandler.stop();
        c.updatePlayInfo({});
        return;
      }
      var tmpPlayInfo=c.playInfo.value;
      tmpPlayInfo["index"]=index;
      tmpPlayInfo["list"]=c.lovedSongs.value;
      c.updatePlayInfo(tmpPlayInfo);
    }
  }

  void reloadList(BuildContext context){
    if(Platform.isIOS){
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("确定要刷新列表吗?"),
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
                  reloadHandler();
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
                  reloadHandler();
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
    if(c.playInfo["name"]=="lovedSongs"){
      reloadHandler();
    }
  }

  final AutoScrollController myScrollController=AutoScrollController();

  void scrollToNowPlay(){
    if(c.playInfo['name']=='lovedSongs' && myScrollController.hasClients){
      myScrollController.scrollToIndex(c.playInfo['index'], preferPosition: AutoScrollPosition.middle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListHeader(pageFrom: "喜欢的歌曲", locate: () => scrollToNowPlay(), refresh: () => reloadList(context), allowLocate: c.pageAsycEn[c.pageIndex]==c.playInfo['name'], cnt: c.lovedSongs.length,),),
        Expanded(
          child: CupertinoScrollbar(
            controller: myScrollController,
            child: Obx(() =>  
              ListView.builder(
                controller: myScrollController,
                itemCount: c.lovedSongs.length,
                itemBuilder: (BuildContext context, int index){
                  return AutoScrollTag(
                    key: ValueKey(index),
                    controller: myScrollController,
                    index: index,
                    child: GestureDetector(
                      onTap: (){
                        playSong(c.lovedSongs[index], index, "lovedSongs", widget.audioHandler);
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
                                        c.lovedSongs[index]["title"],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: c.mainColor
                                        ),
                                      ) : 
                                      Text(
                                        c.lovedSongs[index]["title"],
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
                                              c.lovedSongs[index]["artist"],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: c.mainColor
                                              )
                                            ) : 
                                            Text(
                                              c.lovedSongs[index]["artist"],
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
                                        item: c.lovedSongs[index], 
                                        index: index, 
                                        pageName: "allSongs", 
                                        audioHandler: widget.audioHandler, 
                                        reloadLoved: reloadHandler,
                                        playSong: ()=>playSong(c.lovedSongs[index], index, "lovedSongs", widget.audioHandler)
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
                    ),
                  );
                }
              ),
            )
          ),
        ), 
        SizedBox(height: 70,)
      ],
    );
  }
}