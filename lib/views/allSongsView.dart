// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, invalid_use_of_protected_member, prefer_const_literals_to_create_immutables

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

  var isTap=0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 30,
          color: Colors.white,
          child: Center(child: Text("合计${songList.length}首歌", style: TextStyle(color: c.mainColor),)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: songList.length,
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
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
                  duration: Duration(milliseconds: 300),
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
                              child: Text(
                                (index+1).toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              songList[index]["title"],
                              overflow: TextOverflow.ellipsis,
                            )
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