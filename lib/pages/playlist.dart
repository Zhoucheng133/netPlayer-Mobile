import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
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
      // loading=false;
    });
    Future.delayed(const Duration(milliseconds: 200), (){
      setState(() {
        loading=false;
      });
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
        title: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: showAppbarTitle ? Text(widget.name, key: const Key("1"),) : null,
          ),
        ),
        centerTitle: false,
        actions: [
          Obx(()=>
            IconButton(
              onPressed: pl.nowPlay['playFrom']=='playlist' && pl.nowPlay['fromId']==widget.id ? (){
                controller.scrollToIndex(pl.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
              } : null, 
              icon: const Icon(
                Icons.my_location_rounded,
                size: 20,
              )
            ),
          ),
          const SizedBox(width: 10,)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: loading ? Center(
                key: const Key("0"),
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
              ) : 
              CustomScrollView(
                key: const Key('1'),
                controller: controller,
                slivers: [
                  SliverToBoxAdapter(
                    child: TitleAria(title: widget.name, subtitle: '${ls.length}首歌曲',),
                  ),
                  SliverList.builder(
                    itemCount: ls.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: AutoScrollTag(
                          key: ValueKey(index),
                          index: index,
                          controller: controller,
                          child: SongItem(item: ls[index], index: index, ls: ls, from: 'playlist', listId: widget.id, refresh: () => getList(context),),
                        ),
                      );
                    }
                  )
                ],
              )
            ),
          ),
          const Hero(
            tag: 'playingbar', 
            child: PlayingBar()
          )
        ],
      ),
    );
  }
}