// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, unrelated_type_equality_checks, prefer_const_literals_to_create_immutables, unused_field, prefer_typing_uninitialized_variables
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/components/operations.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:netplayer_mobile/views/allSongsView.dart';
import 'package:netplayer_mobile/views/searchView.dart';
import 'package:netplayer_mobile/components/playingBar.dart';
import 'package:netplayer_mobile/views/lovedSongsView.dart';
import 'package:netplayer_mobile/views/settingsView.dart';
import 'package:netplayer_mobile/views/songListsView.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      settingsView(),
    ];
    super.initState();
  }

  var pageAsyc={
    0: "所有音乐",
    1: "我喜欢的",
    2: "歌单",
    3: "搜索",
    4: "设置",
    5: "播放器",
  };

  String appBarText(){
    return pageAsyc[c.pageIndex.value]!;
  }

  Future<void> cancelFullRandomPlay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFullRandom', false);
    c.updateFullRandom(false);
    // c.updateRandomPlay(false);
    widget.audioHandler.stop();
    c.updatePlayInfo({});
    await prefs.setString("playInfo", "{}");
    c.updateNowDuration(0);
  }

  Future<void> fullRandomPlay() async {
    c.updateFullRandom(true);
    // c.updateRandomPlay(true);
    var tmp=await randomSongRequest();
    tmp=tmp["randomSongs"]["song"][0];
    playSong(tmp, 0, "", widget.audioHandler, isFullRandom: true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFullRandom', true);
  }

  NavigationDestinationLabelBehavior labelBehavior = NavigationDestinationLabelBehavior.onlyShowSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: Obx(() => Text(appBarText())),
        backgroundColor: Colors.white,
        scrolledUnderElevation:0.0,
        foregroundColor: Colors.black,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.black
        ),
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
            c.pageIndex==0 ? 
            Row(
              children: [
                Obx(() => 
                  CircleAvatar(
                    backgroundColor: c.fullRandom==true ? c.mainColor : Colors.white,
                    child: IconButton(
                      onPressed: (){
                        if(c.fullRandom==true){
                          cancelFullRandomPlay();
                        }else{
                          // c.updateFullRandom(true);
                          // c.updateRandomPlay(true);
                          if(Platform.isIOS){
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: Text("随机播放所有歌曲?"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text('取消'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text('继续'),
                                      onPressed: () {
                                        fullRandomPlay();
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
                                  title: Text("随机播放所有歌曲?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      }, 
                                      child: Text("取消")
                                    ),
                                    TextButton(
                                      child: Text('继续'),
                                      onPressed: () {
                                        fullRandomPlay();
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }, 
                      icon: Obx(() => 
                        Icon(
                          Icons.shuffle,
                          size: 23,
                          color: c.fullRandom==true ? Colors.white : Colors.black,
                        )
                      )
                    ),
                  ),
                ),
                SizedBox(width: 15,)
              ],
            ) :
            Container()
          )
        ],
      ),
      bottomNavigationBar: Obx(() => 
        NavigationBar(
          backgroundColor: Colors.white,
          elevation: 0,
          // indicatorColor: c.mainColor,
          onDestinationSelected: (index){
            c.updatePageIndex(index);
          },
          selectedIndex: c.pageIndex.value,
          labelBehavior: labelBehavior,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.music_note),
              label: "所有音乐"
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite),
              label: "我喜欢的"
            ),
            NavigationDestination(
              icon: Icon(Icons.queue_music),
              label: "我的歌单"
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              label: "搜索"
            ),
            NavigationDestination(
              icon: Icon(Icons.settings),
              label: "设置"
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          // Obx(() => allView[c.pageIndex.value]),
          Obx(() => 
            IndexedStack(
              index: c.pageIndex.value,
              children: allView,
            )
          ),
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