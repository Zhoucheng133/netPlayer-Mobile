import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/pages/components/album_item.dart';
import 'package:netplayer_mobile/pages/components/artist_item.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/search_box.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController textController=TextEditingController();
  ScrollController controller=ScrollController();
  bool showAppbarTitle=false;
  final DialogVar d=Get.find();

  Map ls={
    "songs": [],
    "albums": [],
    "artists": []
  };
  String mode='song';
  void changeMode(val){
    setState(() {
      mode=val;
    });
  }

  Future<void> searchHandler(BuildContext context) async {
    Map data=await Operations().search(textController.text, context);
    if(data['songs'].isEmpty && data['albums'].isEmpty && data['artists'].isEmpty){
      if(context.mounted){
        d.showOkDialog(
          context: context,
          okText: "ok".tr,
          title: "searchEmpty".tr,
          content: "tryOtherKeywords".tr
        );
      }
    }else{
      setState(() {
        ls=data;
      });
    }
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

  SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        backgroundColor: s.darkMode.value ? s.bgColor2 : Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
          scrolledUnderElevation:0.0,
          toolbarHeight: 70,
          title: Align(
            alignment: Alignment.centerLeft,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: showAppbarTitle ? Text('search'.tr, key: const Key("1"),) : null,
            ),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: ()=>searchHandler(context),
                child: CupertinoScrollbar(
                  controller: controller,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: controller,
                    slivers: [
                      SliverToBoxAdapter(
                        child: SearchTitleArea(mode: mode, changeMode: (val)=>changeMode(val))
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SearchBox(
                          (context)=>SearchInput(
                            textController: textController, search: ()=>searchHandler(context), mode: mode,
                          ),
                        ),
                      ),
                      mode=='song' ? SliverList.builder(
                        itemCount: ls['songs'].length,
                        itemBuilder: (context, index){
                          return SongItem(item: ls['songs'][index], index: index, ls: ls['songs'], from: 'search', listId: textController.text, );
                        }
                      ) : mode=='album' ? SliverList.builder(
                        itemCount: ls['albums'].length,
                        itemBuilder: (context, index){
                          return AlbumItem(index: index, item: ls['albums'][index]);
                        }
                      ) :  SliverList.builder(
                        itemCount: ls['artists'].length,
                        itemBuilder: (context, index){
                          return ArtistItem(index: index, item: ls['artists'][index]);
                        }
                      )
                    ],
                  ),
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