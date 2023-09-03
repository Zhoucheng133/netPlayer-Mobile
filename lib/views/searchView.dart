// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/operations.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';

class searchView extends StatefulWidget {
  const searchView({super.key, required this.audioHandler});

  final dynamic audioHandler;

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {
  final Controller c = Get.put(Controller());

  var key=TextEditingController();

  List list=[];

  @override
  void initState() {
    super.initState();

    if(c.searchRlt.isNotEmpty && c.searchKey.isNotEmpty){
      setState(() {
        list=c.searchRlt;
        key.text=c.searchKey.value;
      });
    }
  }

  Future<void> searchController() async {
    List tmp=await searchRequest(key.text);
    if(tmp!=[]){
      setState(() {
        list=tmp;
      });
      c.updateSearchKey(key.text);
      c.updatesearchRlt(tmp);
    }
  }

  Future<void> reloadLoved() async {
    var tmp=await lovedSongRequest();
    c.updateLovedSongs(tmp);
    if(c.playInfo["name"]=="lovedSongs"){
      widget.audioHandler.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // color: Colors.red,
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(
                          child: TextField(
                            controller: key,
                            decoration: InputDecoration(
                              // border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent), // 设置失去焦点时的边框颜色
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent), // 设置获取焦点时的边框颜色
                              ),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            style: TextStyle(
                              fontSize: 14
                            ),
                            autocorrect: false,
                            enableSuggestions: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ),
              GestureDetector(
                onTap: (){
                  searchController();
                },
                child: Container(
                  width: 50,
                  height: 60,
                  color: Colors.white,
                  child: Center(
                    child: Icon(
                      Icons.search
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: CupertinoScrollbar(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  onTap: (){
                    playSong(list[index], index, "search", widget.audioHandler);
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
                                    c.playInfo.isNotEmpty && c.playInfo["name"]=="search" && c.playInfo["index"]==index ? 
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
                                  c.playInfo.isNotEmpty && c.playInfo["name"]=="search" && c.playInfo["index"]==index ? 
                                  Text(
                                    list[index]["title"],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: c.mainColor
                                    ),
                                  ) : 
                                  Text(
                                    list[index]["title"],
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
                                      c.fav(list[index]["id"])==false ? 
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
                                        c.playInfo.isNotEmpty && c.playInfo["name"]=="search" && c.playInfo["index"]==index ? 
                                        Text(
                                          list[index]["artist"],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: c.mainColor
                                          )
                                        ) : 
                                        Text(
                                          list[index]["artist"],
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
                                    item: list[index], 
                                    index: index, 
                                    pageName: "search", 
                                    audioHandler: widget.audioHandler,
                                    reloadLoved: reloadLoved, 
                                    playSong: ()=>playSong(list[index], index, "search", widget.audioHandler),
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
                                      c.playInfo.isNotEmpty && c.playInfo["name"]=="search" && c.playInfo["index"]==index ? 
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
        SizedBox(
          height: 70,
        )
      ],
    );
  }
}