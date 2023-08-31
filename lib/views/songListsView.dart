// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, invalid_use_of_protected_member, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:netplayer_mobile/views/listContentView.dart';

class songListsView extends StatefulWidget {
  const songListsView({super.key, required this.audioHandler});

  final dynamic audioHandler;

  @override
  State<songListsView> createState() => _songListsViewState();
}

class _songListsViewState extends State<songListsView> {
  final Controller c = Get.put(Controller());

  var list=[];

  void reloadList(BuildContext context){
    // TODO 刷新歌单
  }

  Future<void> getList() async {
    if(c.playLists.value.isEmpty){
      var tmp=await allListsRequest();
      setState(() {
        list=tmp;
      });
      c.updatePlayLists(list);
    }else{
      setState(() {
        list=c.playLists.value;
      });
    }
  }

  @override
  void initState() {
    getList();

    super.initState();
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
                  "合计${list.length}个歌单", 
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
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index){
                return GestureDetector(
                  onTap: (){
                    // TODO打开歌单
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => listContentView(audioHandler: widget.audioHandler, item: list[index],))
                    );
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
                                  Text(
                                    (index+1).toString(),
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
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
                                Text(
                                  list[index]["name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            )
                          ),
                          GestureDetector(
                            onTap: (){
                              // TODO 按下更多操作
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
                                    Icon(
                                      Icons.more_vert,
                                      size: 20,
                                    )
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