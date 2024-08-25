// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:netplayer_mobile/variables/page_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {

  List ls=[];
  AutoScrollController controller=AutoScrollController();
  bool showAppbarTitle=false;
  bool loading=true;

  Future<void> getList(BuildContext context) async {
    final data=await DataGet().getAll(context);
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

  PageVar p=Get.put(PageVar());
  PlayerVar pl=Get.put(PlayerVar());

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
        actions: [
          IconButton(
            onPressed: (){
              if(pl.nowPlay['playFrom']=='all'){
                controller.scrollToIndex(pl.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
              }
            }, 
            icon: Obx(()=>
              Icon(
                Icons.my_location_rounded,
                size: 20,
                color: pl.nowPlay['playFrom']=='all' ? Colors.black : Colors.grey[400],
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
              ) : ListView(
                key: Key("1"),
                controller: controller,
                children: [
                  TitleAria(title: '所有歌曲', subtitle: '${ls.length}首歌曲'),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: List.generate(ls.length, (index){
                        return AutoScrollTag(
                          controller: controller,
                          index: index,
                          key: ValueKey(index),
                          child: SongItem(item: ls[index], index: index, ls: ls, from: 'all', listId: '',)
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