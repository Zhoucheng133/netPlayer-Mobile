import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/play_check.dart';
import 'package:netplayer_mobile/pages/components/multi_option.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/pages/search_in.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Loved extends StatefulWidget {
  const Loved({super.key});

  @override
  State<Loved> createState() => _LovedState();
}

class _LovedState extends State<Loved> {
  AutoScrollController controller=AutoScrollController();
  bool showAppbarTitle=false;
  final LsVar lsVar=Get.find();

  bool loading=false;

  Future<void> getList(BuildContext context) async {
    setState(() {
      loading=true;
    });

    await PlayCheck().check(context);

    Future.delayed(const Duration(milliseconds: 200), (){
      setState(() {
        loading=false;
      });
    });
  }

  @override
  void initState(){
    super.initState();
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
  void dispose(){
    controller.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      s.selectList.clear();
      s.selectMode.value=false;
    });
    super.dispose();
  }

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
              child: showAppbarTitle ? Text('loved'.tr, key: const Key("1"),) : null,
            ),
          ),
          actions: [
            Obx(()=>
              s.selectMode.value ? TextButton(
                onPressed: (){
                  s.selectMode.value=false;
                  s.selectList.clear();
                }, 
                child: Text('unselect'.tr)
              ) : IconButton(
                onPressed: pl.nowPlay['playFrom']=='loved'? (){
                  controller.scrollToIndex(pl.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
                } : null, 
                icon: const Icon(
                  Icons.my_location_rounded,
                  size: 20,
                )
              ),
            ),
            Obx(
              ()=> s.selectMode.value ? MultiOption(fromPlaylist: false, listId: "",) : IconButton(
                onPressed: lsVar.loved.isEmpty ? null : (){
                  Get.to(()=> SearchIn(ls: lsVar.loved, from: 'loved', mode: 'song', listId: '',));
                }, 
                icon: const Icon(Icons.search_rounded, size: 22,)
              ),
            ),
            const SizedBox(width: 10,)
          ],
        ),
        body: Column(
          children: [
            Obx(
              ()=> Expanded(
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
                          key: const Key('1'),
                          controller: controller,
                          slivers: [
                            SliverToBoxAdapter(
                              child: TitleArea(title: 'loved'.tr, subtitle: '${lsVar.loved.length} ${"songsEnd".tr}', ),
                            ),
                            SliverList.builder(
                              itemCount: lsVar.loved.length,
                              itemBuilder: (context, index){
                                return AutoScrollTag(
                                  key: ValueKey(index),
                                  index: index,
                                  controller: controller,
                                  child: SongItem(item: lsVar.loved[index], index: index, ls: lsVar.loved, from: 'loved', listId: '',),
                                );
                              }
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ),
              ),
            ),
            const PlayingBar()
          ],
        ),
      ),
    );
  }
}