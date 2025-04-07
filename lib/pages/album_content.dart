import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class AlbumContent extends StatefulWidget {

  final String album;
  final String id;

  const AlbumContent({super.key, required this.album, required this.id});

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
              child: showAppbarTitle ? Text("专辑: ${widget.album}", key: const Key("1"),) : null,
            ),
          ),
          centerTitle: false,
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
                CupertinoScrollbar(
                  controller: controller,
                  child: CustomScrollView(
                    key: const Key("1"),
                    controller: controller,
                    slivers: [
                      SliverToBoxAdapter(
                        child: TitleArea(title: "专辑: ${widget.album}", subtitle: '${ls.length}首歌曲',),
                      ),
                      SliverList.builder(
                        itemCount: ls.length,
                        itemBuilder: (context, index){
                          return SongItem(item: ls[index], index: index, ls: ls, from: 'album', listId: widget.id,);
                        }
                      )
                    ],
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