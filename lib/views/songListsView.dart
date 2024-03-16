// ignore_for_file: prefer_const_constructors, camel_case_types, file_names, invalid_use_of_protected_member, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/listHeader.dart';
import 'package:netplayer_mobile/components/operations.dart';
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

  // var list=[];

  void reloadList(BuildContext context){
    if(Platform.isIOS){
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("确定要刷新歌单列表吗?"),
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
                  // var tmp=await allListsRequest();
                  // setState(() {
                  //   list=tmp;
                  // });
                  // c.updatePlayLists(list);
                  var tmp=await allListsRequest();
                  c.updatePlayLists(tmp);
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
            title: Text("确定要刷新歌单列表吗?"),
            content: Text("这不会影响当前播放"),
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
                  // var tmp=await allListsRequest();
                  // setState(() {
                  //   list=tmp;
                  // });
                  // c.updatePlayLists(list);
                  var tmp=await allListsRequest();
                  c.updatePlayLists(tmp);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  Future<void> getList() async {
    var tmp=await allListsRequest();
    c.updatePlayLists(tmp);
    // if(c.playLists.value.isEmpty){
    //   var tmp=await allListsRequest();
    //   setState(() {
    //     list=tmp;
    //   });
    //   c.updatePlayLists(list);
    // }else{
    //   setState(() {
    //     list=c.playLists.value;
    //   });
    // }
  }

  final myScrollController=ScrollController();

  @override
  void initState() {
    getList();

    super.initState();
  }

  Future<void> forceReload() async {
    var tmp=await allListsRequest();
    // setState(() {
    //   list=tmp;
    // });
    c.updatePlayLists(tmp);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => ListHeader(pageFrom: "歌单列表", locate: () => {}, refresh: () => reloadList(context), allowLocate: c.pageAsycEn[c.pageIndex]==c.playInfo['name'], cnt: c.playLists.length,),),
        Expanded(
          child: CupertinoScrollbar(
            controller: myScrollController,
            child: Obx(() => 
              ListView.builder(
                controller: myScrollController,
                itemCount: c.playLists.length,
                itemBuilder: (BuildContext context, int index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => listContentView(audioHandler: widget.audioHandler, item: c.playLists[index],))
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
                                    c.playLists[index]["name"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
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
                                    return listOperation(
                                      item: c.playLists[index], 
                                      reloadList: forceReload,

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
            )
          ),
        ), 
        SizedBox(height: 70,)
      ],
    );
  }
}