import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/pages/search_in.dart';
import 'package:netplayer_mobile/variables/download_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {

  SettingsVar s=Get.find();
  List<dynamic> ls=[];
  bool showAppbarTitle=false;
  AutoScrollController controller=AutoScrollController();
  final DownloadVar downloadVar=Get.find();

  Future<void> init() async {
    final data=await downloadVar.getDownloadList();
    setState((){
      ls=data;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: s.darkMode.value ? s.bgColor2 : Colors.white,
        appBar: AppBar(
          backgroundColor: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
          scrolledUnderElevation:0.0,
          toolbarHeight: 70,
          title: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: showAppbarTitle ? Text('albums'.tr, key: const Key("1"),) : null,
            ),
          ),
          actions: [
            IconButton(
              onPressed: ls.isEmpty ? null : (){
                Get.to(()=> SearchIn(ls: ls, from: 'download', mode: 'song', listId: '',));
              }, 
              icon: const Icon(Icons.search_rounded, size: 22,)
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
                        child: TitleArea(title: 'downloaded'.tr, subtitle: '${ls.length} ${"songsEnd".tr}',),
                      ),
                      SliverList.builder(
                        itemCount: ls.length,
                        itemBuilder: (context ,index){
                          return SongItem(item: ls[index], index: index, ls: ls, from: "download", listId: "");
                        }
                      )
                    ],
                  ),
                )
              ),
            ),
            const PlayingBar()
          ],
        )
    );
  }
}