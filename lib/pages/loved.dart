import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
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
          centerTitle: false,
          title: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: showAppbarTitle ? const Text('喜欢的歌曲', key: Key("1"),) : null,
            ),
          ),
          actions: [
            Obx(()=>
              IconButton(
                onPressed: pl.nowPlay['playFrom']=='loved'? (){
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
                RefreshIndicator(
                  onRefresh: () => getList(context),
                  child: CupertinoScrollbar(
                    controller: controller,
                    child: CustomScrollView(
                      key: const Key('1'),
                      controller: controller,
                      slivers: [
                        SliverToBoxAdapter(
                          child: TitleArea(title: '喜欢的歌曲', subtitle: '${ls.length}首歌曲', ),
                        ),
                        SliverList.builder(
                          itemCount: ls.length,
                          itemBuilder: (context, index){
                            return AutoScrollTag(
                              key: ValueKey(index),
                              index: index,
                              controller: controller,
                              child: SongItem(item: ls[index], index: index, ls: ls, from: 'loved', listId: '',),
                            );
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