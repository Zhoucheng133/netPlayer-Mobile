// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, unrelated_type_equality_checks, prefer_const_literals_to_create_immutables, unused_field, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/operations.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:netplayer_mobile/views/allSongsView.dart';
import 'package:netplayer_mobile/views/searchView.dart';
import 'package:netplayer_mobile/components/playingBar.dart';
import 'package:netplayer_mobile/views/lovedSongsView.dart';
import 'package:netplayer_mobile/views/aboutView.dart';
import 'package:netplayer_mobile/views/songListsView.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class mainView extends StatefulWidget {
  const mainView({super.key, required this.audioHandler});
  final dynamic audioHandler;

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  final Controller c = Get.put(Controller());

  List<Widget> allView=[];

  @override
  void initState() {
    allView=[
      allSongsView(audioHandler: widget.audioHandler,),
      lovedSongsView(audioHandler: widget.audioHandler,),
      songListsView(audioHandler: widget.audioHandler,),
      searchView(audioHandler: widget.audioHandler,),
      aboutView(),
    ];
    super.initState();
  }

  var pageAsyc={
    0: "所有音乐",
    1: "我喜欢的",
    2: "歌单",
    3: "搜索",
    4: "关于",
    5: "播放器",
  };

  String appBarText(){
    return pageAsyc[c.pageIndex.value]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Obx(() => Text(appBarText())),
        // title: Text("所有音乐"),
        backgroundColor: Colors.white,
        foregroundColor: c.mainColor,
        actions: [
          Obx(() => 
            c.pageIndex==2 ?
            IconButton(
              onPressed: (){
                addList(context);
              }, 
              icon: Icon(
                Icons.add_rounded,
                size: 30,
              )
            ) :
            Container()
          )
        ],
      ),
      bottomNavigationBar: Obx(() => 
        BottomNavigationBar(
          elevation: 0,
          selectedItemColor: c.mainColor,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14.0,
          unselectedFontSize: 14.0,
          onTap: (index){
            c.updatePageIndex(index);
          },
          currentIndex: c.pageIndex.value,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: "所有音乐"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "我喜欢的"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.queue_music),
              label: "我的歌单"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "搜索"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: "关于"
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Obx(() => allView[c.pageIndex.value]),
          Obx(() => 
            c.pageIndex.value<4 ?
            Positioned(
              bottom: 0,
              height: 70,
              child: Container(
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
              )
            ) : SizedBox(width: 0, height: 0,),
          )
        ],
      )
    );
  }
}