import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
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
      loading=false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
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
            ) : ListView.builder(
              key: const Key("1"),
              controller: controller,
              itemCount: ls.length + 1, // +1 是为了包括 `TitleAria`
              itemBuilder: (context, index) {
                if (index == 0) {
                  // 第一个 item 是 `TitleAria`
                  return TitleAria(
                    title: "专辑: ${widget.album}",
                    subtitle: '${ls.length}首歌曲',
                  );
                } else {
                  // 其余的 items 是歌曲列表
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SongItem(
                      item: ls[index - 1],
                      index: index - 1,
                      ls: ls,
                      from: 'album',
                      listId: widget.id,
                    ),
                  );
                }
              },
            ),
          ),
          const Hero(
            tag: 'playingbar', 
            child: PlayingBar()
          )
        ],
      ),
    );
  }
}