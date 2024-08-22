// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:netplayer_mobile/variables/page_var.dart';

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {

  List ls=[];
  ScrollController controller=ScrollController();
  bool showAppbarTitle=false;

  Future<void> getList() async {
    final data=await DataGet().getAllSongs();
    setState(() {
      ls=data;
    });
  }

  @override
  void initState(){
    super.initState();
    getList();
    controller.addListener((){
      // print(controller.offset);
      if(controller.offset>60){
        setState(() {
          showAppbarTitle=true;
        });
      }else{
        setState(() {
          showAppbarTitle=false;
        });
      }
    });
  }

  PageVar p=Get.put(PageVar());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        title: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: showAppbarTitle ? Text('所有歌曲', key: Key("1"),) : null,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: controller,
              children: [
                TitleAria(title: '所有歌曲', subtitle: '${ls.length}首歌曲'),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: List.generate(ls.length, (index){
                      return SongItem(item: ls[index], index: index);
                    }),
                  ),
                )
              ]
            ),
          ),
          Hero(
            tag: 'playingbar', 
            child: PlayingBar()
          )
        ],
      ),
    );
  }
}