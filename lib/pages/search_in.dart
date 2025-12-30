import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/components/album_item.dart';
import 'package:netplayer_mobile/pages/components/artist_item.dart';
import 'package:netplayer_mobile/pages/components/multi_option.dart';
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

  @override
  void dispose(){
    controller.dispose();
    focus.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      s.selectList.clear();
      s.selectMode.value=false;
    });
    super.dispose();
  }

  TextEditingController textController=TextEditingController(text: '');
  ScrollController controller=ScrollController();
  bool showAppbarTitle=false;
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
    }else if(widget.mode=='artist'){
      setState(() {
        filtered = widget.ls
        .asMap()
        .entries
        .where((entry){
          final text = textController.text.toLowerCase();
          final name = entry.value['name']?.toLowerCase() ?? '';
          return name.contains(text);
        }).map((entry) => {
          'index': entry.key,
          'item': entry.value,
        }).toList();
      });
    }else if(widget.mode=='album'){
      setState(() {
        filtered = widget.ls
        .asMap()
        .entries
        .where((entry){
          final text = textController.text.toLowerCase();
          final title = entry.value['title']?.toLowerCase() ?? '';
          final artist = entry.value['artist']?.toLowerCase() ?? '';
          return title.contains(text) || artist.contains(text);
        }).map((entry) => {
          'index': entry.key,
          'item': entry.value,
        }).toList();
      });
    }
  }

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
              child: CupertinoScrollbar(
                controller: controller,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller,
                  slivers: [
                    SliverToBoxAdapter(
                      child: SearchTitleArea(mode: widget.mode, changeMode: (val){}, disableMode: true,)
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SearchBox(
                        (context)=>SearchInput(
                          textController: textController, focus: focus, search: searchHandler, mode: widget.mode,
                        ),
                      ),
                    ),
                    widget.mode=='song' ? SliverList.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index){
                        final data = filtered[index];
                        return SongItem(
                          item: data['item'],
                          index: data['index'],
                          ls: widget.ls,
                          from: widget.from,
                          listId: widget.listId,
                        );
                      }
                    ) : widget.mode=='album' ? SliverList.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index){
                        final data = filtered[index];
                        return AlbumItem(index: data['index'], item: data['item']);
                      }
                    ) :  SliverList.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index){
                        final data = filtered[index];
                        return ArtistItem(index: data['index'], item: data['item']);
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