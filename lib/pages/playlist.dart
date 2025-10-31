import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/pages/search_in.dart';
import 'package:netplayer_mobile/pages/skeletons/song_skeleton.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Playlist extends StatefulWidget {

  final String id;
  final String name;
  final int songCount;

  const Playlist({super.key, required this.id, required this.name, required this.songCount});

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

  PlayerVar pl=Get.find();
  SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        backgroundColor: s.darkMode.value ? s.bgColor2 : Colors.white,
        appBar: AppBar(
          backgroundColor: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
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
            IconButton(
              onPressed: ls.isEmpty ? null : (){
                Get.to(()=> SearchIn(ls: ls, from: 'playlist', mode: 'song', listId: widget.id,));
              }, 
              icon: const Icon(Icons.search_rounded, size: 22,)
            ),
            const SizedBox(width: 10,)
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: RefreshIndicator(
                  onRefresh: () => getList(context),
                  child: CupertinoScrollbar(
                    controller: controller,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      key: const Key('1'),
                      controller: controller,
                      slivers: [
                        SliverToBoxAdapter(
                          child: TitleArea(title: widget.name, subtitle: '${ loading ? widget.songCount.toString() : ls.length}首歌曲',),
                        ),
                        !loading ? SliverList.builder(
                          itemCount: ls.length,
                          itemBuilder: (context, index){
                            return AutoScrollTag(
                              key: ValueKey(index),
                              index: index,
                              controller: controller,
                              child: SongItem(item: ls[index], index: index, ls: ls, from: 'playlist', listId: widget.id, refresh: () => getList(context),),
                            );
                          }
                        ) : SliverList.builder(
                          itemCount: widget.songCount,
                          itemBuilder: (context, index){
                            return const SongSkeleton(showLoved: false);
                          }
                        )
                      ],
                    ),
                  ),
                )
              ),
            ),
            const PlayingBar()
          ],
        ),
      ),
    );
  }
}