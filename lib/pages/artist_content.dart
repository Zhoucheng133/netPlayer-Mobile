import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/album_item.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ArtistContent extends StatefulWidget {

  final String id;
  final String artist;

  const ArtistContent({super.key, required this.id, required this.artist});

  @override
  State<ArtistContent> createState() => _ArtistContentState();
}

class _ArtistContentState extends State<ArtistContent> {
  List ls=[];
  AutoScrollController controller=AutoScrollController();
  bool showAppbarTitle=false;
  bool loading=true;

  Future<void> getList(BuildContext context) async {
    final data=await DataGet().getArtist(widget.id, context);
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
              child: showAppbarTitle ? Text('艺人: ${widget.artist}', key: const Key("1"),) : null,
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
                        child: TitleArea(title: '艺人: ${widget.artist}', subtitle: '${ls.length}张专辑',),
                      ),
                      SliverList.builder(
                        itemCount: ls.length,
                        itemBuilder: (context, index){
                          return AlbumItem(index: index, item: ls[index],);
                        }
                      )
                    ],
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