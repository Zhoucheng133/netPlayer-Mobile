// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, invalid_use_of_protected_member, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';

class allSongsView extends StatefulWidget {
  const allSongsView({super.key});

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
        // TODO 登录错误，返回登录页面
      }else{
        setState(() {
          songList=tmp["randomSongs"]["song"];
        });
        c.updateAllSongs(songList);
        print("请求+1");
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
          content: Text("注意这会打乱原有的歌曲顺序!"),
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
                setState(() {
                  songList=tmp["randomSongs"]["song"];
                });
                c.updateAllSongs(songList);

                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  var isTap=0;

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
          child: ListView.builder(
            itemCount: songList.length,
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                onTap: (){
                  print("点击播放!");
                },
                onTapUp: (detail){
                  setState(() {
                    isTap=0;
                  });
                },
                onTapDown: (detail){
                  setState(() {
                    isTap=index+1;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isTap==index+1 ? Colors.grey[200] : Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,10,0),
                    child: SizedBox(
                      height: 60,
                      // color: Colors.white,
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
                                Obx(() => 
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
                                )
                              ],
                            )
                          ),
                          GestureDetector(
                            onTap: (){
                              print("更多...");
                              setState(() {
                                isTap=0;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: double.infinity,
                              child: Center(
                                child: Obx(() => 
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
                                )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        ), 
        SizedBox(height: 70,)
      ],
    );
  }
}