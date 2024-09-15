import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netplayer_mobile/operations/operations.dart';
import 'package:netplayer_mobile/pages/components/album_item.dart';
import 'package:netplayer_mobile/pages/components/artist_item.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/search_box.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController textController=TextEditingController();
  FocusNode focus=FocusNode();
  ScrollController controller=ScrollController();
  bool showAppbarTitle=false;
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
        showOkAlertDialog(
          context: context,
          okLabel: "好的",
          title: "没有搜索到任何内容",
          message: "请尝试换一个关键词"
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
    focus.requestFocus();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        title: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: showAppbarTitle ? const Text('搜索', key: Key("1"),) : null,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: CupertinoScrollbar(
              controller: controller,
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  SliverToBoxAdapter(
                    child: SearchTitleArea(mode: mode, changeMode: (val)=>changeMode(val))
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SearchBox(
                      (context)=>SearchInput(
                        textController: textController, focus: focus, search: ()=>searchHandler(context), mode: mode,
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
          const PlayingBar()
        ],
      ),
    );
  }
}