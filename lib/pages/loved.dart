// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Loved extends StatefulWidget {
  const Loved({super.key});

  @override
  State<Loved> createState() => _LovedState();
}

class _LovedState extends State<Loved> {

  List ls=[];
  AutoScrollController controller=AutoScrollController();
  bool showAppbarTitle=false;
  bool loading=true;

  Future<void> getList(BuildContext context) async {
    final data=await DataGet().getLoved(context);
    setState(() {
      ls=data;
      loading=false;
    });
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getList(context);
    });
    controller.addListener((){
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

  PlayerVar pl=Get.put(PlayerVar());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        centerTitle: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: showAppbarTitle ? Text('喜欢的歌曲', key: Key("1"),) : null,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              if(pl.nowPlay['playFrom']=='loved'){
                controller.scrollToIndex(pl.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
              }
            }, 
            icon: Obx(()=>
              Icon(
                Icons.my_location_rounded,
                size: 20,
                color: pl.nowPlay['playFrom']=='loved' ? Colors.black : Colors.grey[400],
              )
            )
          ),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: loading ? Center(
                key: Key("0"),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingAnimationWidget.beat(
                      color: Colors.blue, 
                      size: 30
                    ),
                    const SizedBox(height: 10,),
                    const Text('加载中')
                  ],
                ),
              ) :  ListView(
                key: Key("1"),
                controller: controller,
                children: [
                  TitleAria(title: '喜欢的歌曲', subtitle: '${ls.length}首歌曲'),
                  Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: List.generate(ls.length, (index){
                          return AutoScrollTag(
                            key: ValueKey(index),
                            index: index,
                            controller: controller,
                            child: SongItem(item: ls[index], index: index, ls: ls, from: 'loved', listId: '',)
                          );
                        }),
                      ),
                    )
                ]
              ),
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