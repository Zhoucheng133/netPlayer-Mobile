import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/pages/search_in.dart';
import 'package:netplayer_mobile/pages/skeletons/song_skeleton.dart';
import 'package:netplayer_mobile/variables/page_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
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
  final UserVar u=Get.find();

  Future<void> getList(BuildContext context) async {
    final data=await DataGet().getAll(context);
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

  PageVar p=Get.find();
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
              child: showAppbarTitle ? const Text('所有歌曲', key: Key("1"),) : null,
            ),
          ),
          centerTitle: false,
          actions: [
            Obx(()=>
              IconButton(
                onPressed: pl.nowPlay['playFrom']=='all' ? (){
                  controller.scrollToIndex(pl.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
                } : null,
                icon: const Icon(
                  Icons.my_location_rounded,
                  size: 20,
                )
              ),
            ),
            IconButton(
              onPressed: (){
                Get.to(()=> SearchIn(ls: ls, from: 'all', mode: 'song', listId: '',));
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
                child: AbsorbPointer(
                  absorbing: loading,
                  child: RefreshIndicator(
                    onRefresh: () => getList(context),
                    child: CupertinoScrollbar(
                      controller: controller,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        key: const Key("1"),
                        controller: controller,
                        slivers: [
                          SliverToBoxAdapter(
                            child: TitleArea(title: '所有歌曲', subtitle: '${ u.authorization.value.isEmpty && ls.length >= 500 ? "> ${ls.length}" : ls.length}首歌曲', showWarning: u.authorization.value.isEmpty && ls.length >= 500,),
                          ),
                          !loading ? SliverList.builder(
                            itemCount: ls.length,
                            itemBuilder: (context, index){
                              return AutoScrollTag(
                                controller: controller,
                                index: index,
                                key: ValueKey(index),
                                child: SongItem(item: ls[index], index: index, ls: ls, from: 'all', listId: '', ),
                              );
                            },
                          ) : SliverList.builder(
                            itemCount: 20,
                            itemBuilder: (context, _){
                              return const SongSkeleton();
                            }
                          )
                        ],
                      ),
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