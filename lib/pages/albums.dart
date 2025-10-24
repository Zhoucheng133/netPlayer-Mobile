import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/album_item.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/pages/skeletons/album_skeleton.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Albums extends StatefulWidget {
  const Albums({super.key});

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {

  List ls=[];
  AutoScrollController controller=AutoScrollController();
  bool showAppbarTitle=false;
  bool loading=true;

  Future<void> getList(BuildContext context) async {
    final data=await DataGet().getAlbums(context);
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
              child: showAppbarTitle ? const Text('专辑', key: Key("1"),) : null,
            ),
          ),
          centerTitle: false,
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
                      key: const Key("1"),
                      controller: controller,
                      slivers: [
                        SliverToBoxAdapter(
                          child: TitleArea(title: '专辑', subtitle: '${ls.length}张专辑'),
                        ),
                        !loading ? SliverList.builder(
                          itemCount: ls.length,
                          itemBuilder: (context, index){
                            return AlbumItem(index: index, item: ls[index]);
                          }
                        ) : SliverList.builder(
                          itemCount: 20,
                          itemBuilder: (context, index) {
                            return const AlbumSkeleton();
                          },
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