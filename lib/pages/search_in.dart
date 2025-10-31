import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/components/album_item.dart';
import 'package:netplayer_mobile/pages/components/artist_item.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/search_box.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class SearchIn extends StatefulWidget {

  final List ls;
  final String from;
  final String mode;
  final String listId;

  const SearchIn({super.key, required this.ls, required this.from, required this.mode, required this.listId});

  @override
  State<SearchIn> createState() => _SearchInState();
}

class _SearchInState extends State<SearchIn> {

  SettingsVar s=Get.find();

  TextEditingController textController=TextEditingController(text: '');
  ScrollController controller=ScrollController();
  bool showAppbarTitle=false;
  String mode='song';
  FocusNode focus=FocusNode();

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

  List filtered=[];

  void searchHandler(){
    if(widget.mode=='song'){
      setState(() {
        filtered = widget.ls
        .asMap()
        .entries
        .where((entry){
          final text = textController.text.toLowerCase();
          final title = entry.value['title']?.toLowerCase() ?? '';
          final artist = entry.value['artist']?.toLowerCase() ?? '';
          return title.contains(text) || artist.contains(text);
        })
        .map((entry) => {
          'index': entry.key,
          'item': entry.value,
        })
        .toList();
      });
    }
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
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SearchTitleArea(mode: mode, changeMode: (val){}, disableMode: true,)
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SearchBox(
                        (context)=>SearchInput(
                          textController: textController, focus: focus, search: searchHandler, mode: mode,
                        ),
                      ),
                    ),
                    mode=='song' ? SliverList.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index){
                        // return widget.ls[index]['title'].toLowerCase().contains(textController.text.toLowerCase()) ?
                        // SongItem(item: widget.ls[index], index: index, ls: widget.ls, from: widget.from, listId: widget.listId, ) : Container();
                        final data = filtered[index];
                        return SongItem(
                          item: data['item'],
                          index: data['index'], // ✅ 这里是原始 index
                          ls: widget.ls,
                          from: widget.from,
                          listId: widget.listId,
                        );
                      }
                    ) : mode=='album' ? SliverList.builder(
                      itemCount: widget.ls.length,
                      itemBuilder: (context, index){
                        return AlbumItem(index: index, item: widget.ls[index]);
                      }
                    ) :  SliverList.builder(
                      itemCount: widget.ls.length,
                      itemBuilder: (context, index){
                        return ArtistItem(index: index, item: widget.ls[index]);
                      }
                    )
                  ],
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