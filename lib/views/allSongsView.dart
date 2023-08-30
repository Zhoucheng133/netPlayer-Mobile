// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, invalid_use_of_protected_member, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously, unused_element, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/operations.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';

class allSongsView extends StatefulWidget {
  const allSongsView({super.key, required this.audioHandler});
  final dynamic audioHandler;

  @override
  State<allSongsView> createState() => _allSongsViewState();
}

class _allSongsViewState extends State<allSongsView> {
  final Controller c = Get.put(Controller());

  List songList=[];

  Future<void> getList() async {
    
    if(c.allSongs.value.isEmpty){
      var tmp=await allSongsRequest();
      if(tmp["status"]!="ok"){
        c.updateLogin(false);
      }else{
        var tmpList=tmp["randomSongs"]["song"];
        tmpList.sort((a, b) {
          DateTime dateTimeA = DateTime.parse(a['created']);
          DateTime dateTimeB = DateTime.parse(b['created']);
          return dateTimeB.compareTo(dateTimeA);
        });
        setState(() {
          songList=tmpList;
        });
        c.updateAllSongs(songList);
        // print("请求+1");
      }
    }else{
      setState(() {
        songList=c.allSongs.value;
      });
    }
    // print(songList.length);
  }

  @override
  void initState() {
    super.initState();

    getList();
  }

  void reloadList(BuildContext context){
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text("确定要刷新所有歌曲列表吗?"),
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
                var tmp=await allSongsRequest();
                var tmpList=tmp["randomSongs"]["song"];
                tmpList.sort((a, b) {
                  DateTime dateTimeA = DateTime.parse(a['created']);
                  DateTime dateTimeB = DateTime.parse(b['created']);
                  return dateTimeB.compareTo(dateTimeA);
                });
                setState(() {
                  songList=tmpList;
                });
                c.updateAllSongs(songList);
                if(c.playInfo["name"]=="allSongs"){
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
            child: ListView.builder(
              itemCount: songList.length,
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  onTap: (){
                    playSong(songList[index], index, "allSongs", widget.audioHandler);
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
                                    c.playInfo.isNotEmpty && c.playInfo["name"]=="allSongs" && c.playInfo["index"]==index ? 
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
                                  c.playInfo.isNotEmpty && c.playInfo["name"]=="allSongs" && c.playInfo["index"]==index ? 
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
                                    songList[index]["starred"]==null ? 
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
                                    Expanded(
                                      child: Obx(() => 
                                        c.playInfo.isNotEmpty && c.playInfo["name"]=="allSongs" && c.playInfo["index"]==index ? 
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
                                      c.playInfo.isNotEmpty && c.playInfo["name"]=="allSongs" && c.playInfo["index"]==index ? 
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