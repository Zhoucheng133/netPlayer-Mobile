// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Playlist extends StatefulWidget {

  final String id;
  final String name;

  const Playlist({super.key, required this.id, required this.name});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {

  List ls=[];
  AutoScrollController controller=AutoScrollController();
  bool showAppbarTitle=false;
  bool loading=true;

  Future<void> getList(BuildContext context) async {
    final data=await DataGet().getPlayList(context, widget.id);
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
            child: showAppbarTitle ? Text(widget.name, key: Key("1"),) : null,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
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
                TitleAria(title: widget.name, subtitle: '${ls.length}首歌曲'),
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: List.generate(ls.length, (index){
                        return SongItem(item: ls[index], index: index, ls: ls, from: 'playlist', listId: widget.id, refresh: ()=>getList(context),);
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