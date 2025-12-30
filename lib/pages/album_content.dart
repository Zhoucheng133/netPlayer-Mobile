import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/multi_option.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/pages/skeletons/song_skeleton.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class AlbumContent extends StatefulWidget {

  final String album;
  final String id;
  final int songCount;

  const AlbumContent({super.key, required this.album, required this.id, this.songCount=0});

  @override
  State<AlbumContent> createState() => _AlbumContentState();
}

class _AlbumContentState extends State<AlbumContent> {
  List ls=[];
  AutoScrollController controller=AutoScrollController();
  bool showAppbarTitle=false;
  bool loading=true;

  Future<void> getList(BuildContext context) async {
    final data=await DataGet().getAlbum(widget.id, context);
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

  @override
  void dispose(){
    s.selectList.clear();
    s.selectMode.value=false;
    controller.dispose();
    super.dispose();
  }

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
              child: showAppbarTitle ? Text("${'album'.tr}: ${widget.album}", key: const Key("1"),) : null,
            ),
          ),
          centerTitle: false,
          actions: [
            Obx(()=>
              s.selectMode.value ? TextButton(
                onPressed: (){
                  s.selectMode.value=false;
                  s.selectList.clear();
                }, 
                child: Text('unselect'.tr)
              ) : Container()
            ),
            Obx(()=> 
              s.selectMode.value ? MultiOption(fromPlaylist: false, listId: "",) : Container()
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
                  onRefresh: ()=>getList(context),
                  child: CupertinoScrollbar(
                    controller: controller,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      key: const Key("1"),
                      controller: controller,
                      slivers: [
                        SliverToBoxAdapter(
                          child: TitleArea(title: "${'album'.tr}: ${widget.album}", subtitle: '${ls.length} ${"songsEnd".tr}',),
                        ),
                        !loading ? SliverList.builder(
                          itemCount: ls.length,
                          itemBuilder: (context, index){
                            return SongItem(item: ls[index], index: index, ls: ls, from: 'album', listId: widget.id,);
                          }
                        ) : SliverList.builder(
                          itemCount: widget.songCount > 0 ? widget.songCount : 20,
                          itemBuilder: (context, index) {
                            return const SongSkeleton();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ),
            const PlayingBar()
          ],
        ),
      ),
    );
  }
}