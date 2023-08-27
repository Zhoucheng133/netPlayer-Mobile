// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, unrelated_type_equality_checks, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:netplayer_mobile/views/allSongsView.dart';
import 'package:netplayer_mobile/views/artistsView.dart';
import 'package:netplayer_mobile/views/lovedSongsView.dart';
import 'package:netplayer_mobile/views/settingsView.dart';
import 'package:netplayer_mobile/views/songListsView.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  final Controller c = Get.put(Controller());

  List<Widget> allView=[
    allSongsView(),
    lovedSongsView(),
    songListsView(),
    artistsView(),
    settingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Obx(() => Text(c.pageAsyc[c.pageIndex]!)),
      ),
      bottomNavigationBar: Obx(() => 
        BottomNavigationBar(
          selectedItemColor: c.mainColor,
          unselectedItemColor: Colors.grey,
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
              icon: Icon(Icons.mic),
              label: "艺人"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "设置"
            )
          ],
        ),
      ),
      body: Obx(() => allView[c.pageIndex.value])
    );
  }
}