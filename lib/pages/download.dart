import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/components/multi_option.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item_download.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/variables/download_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {

  SettingsVar s=Get.find();
  bool showAppbarTitle=false;
  AutoScrollController controller=AutoScrollController();
  final DownloadVar downloadVar=Get.find();
  final PlayerVar pl=Get.find();

  List selected=[];

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      s.selectList.clear();
      s.selectMode.value=false;
    });
    super.dispose();
  }

  @override
  void initState() {
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

  void toggleSelect(Map target){
    final index=selected.indexWhere((item)=>item['id']==target['id']);
    if(index==-1){
      setState(() {
        selected.add(target);
      });
    }else{
      setState(() {
        selected.removeAt(index);
      });
    }
  }

  bool isSelected(Map target){
    return selected.indexWhere((item)=>item['id']==target['id'])!=-1;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
          backgroundColor: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
          appBar: AppBar(
            backgroundColor: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
            scrolledUnderElevation:0.0,
            toolbarHeight: 70,
            title: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: showAppbarTitle ? Text('downloaded'.tr, key: const Key("1"),) : null,
              ),
            ),
            actions: [
              Obx(()=>
                s.selectMode.value ? TextButton(
                  onPressed: (){
                    s.selectMode.value=false;
                    s.selectList.clear();
                    setState(() {
                      selected.clear();
                    });
                  }, 
                  child: Text('unselect'.tr)
                ) : IconButton(
                  onPressed: pl.nowPlay['playFrom']=='download' ? (){
                    controller.scrollToIndex(pl.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
                  } : null,
                  icon: const Icon(
                    Icons.my_location_rounded,
                    size: 20,
                  )
                ),
              ),
              Obx(()=>
                s.selectMode.value ? MultiOption(fromPlaylist: false, listId: "", fromDownload: true, target: selected,) : Container()
              ),
              const SizedBox(width: 10,)
            ],
            centerTitle: false,
          ),
          body: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: CupertinoScrollbar(
                    controller: controller,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      key: const Key("1"),
                      controller: controller,
                      slivers: [
                        SliverToBoxAdapter(
                          child: TitleArea(title: 'downloaded'.tr, subtitle: '${downloadVar.downloadList.length} ${"songsEnd".tr}',),
                        ),
                        SliverList.builder(
                          itemCount: downloadVar.downloadList.length,
                          itemBuilder: (context ,index){
                            return AutoScrollTag(
                              controller: controller,
                              index: index,
                              key: ValueKey(index),
                              child: SongItemDownload(
                                index: index, 
                                item: downloadVar.downloadList[index].getInfo(), 
                                onSelected: (value)=>toggleSelect(value), 
                                selected: isSelected(downloadVar.downloadList[index].getInfo()),
                              )
                            );
                          }
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            color: s.darkMode.value ? s.bgColor2 : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              ),
              const PlayingBar()
            ],
          )
      ),
    );
  }
}