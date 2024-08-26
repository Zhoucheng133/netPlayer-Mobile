import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/song_item.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Loved extends StatefulWidget {
  const Loved({super.key});

  @override
  State<Loved> createState() => _LovedState();
}

class _LovedState extends State<Loved> {

  List ls=[];
  AutoScrollController controller=AutoScrollController();
  bool showAppbarTitle=false;
  bool loading=true;

  Future<void> getList(BuildContext context) async {
    final data=await DataGet().getLoved(context);
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

  PlayerVar pl=Get.put(PlayerVar());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        centerTitle: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: showAppbarTitle ? const Text('喜欢的歌曲', key: Key("1"),) : null,
          ),
        ),
        actions: [
          Obx(()=>
            IconButton(
              onPressed: pl.nowPlay['playFrom']=='loved'? (){
                controller.scrollToIndex(pl.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
              } : null, 
              icon: const Icon(
                Icons.my_location_rounded,
                size: 20,
              )
            ),
          ),
          const SizedBox(width: 10,)
        ],
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
              ) :  ListView.builder(
                key: const Key("1"),
                controller: controller,
                itemCount: ls.length + 1, // +1 是为了包括 `TitleAria`
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // 第一个 item 是 `TitleAria`
                    return TitleAria(
                      title: '喜欢的歌曲',
                      subtitle: '${ls.length}首歌曲',
                    );
                  } else {
                    // 其余的 items 是歌曲列表
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: AutoScrollTag(
                        key: ValueKey(index - 1), // 使用 index - 1 作为 key，保持一致性
                        index: index - 1, // 由于 `TitleAria` 占用了第一个位置，所以要减 1
                        controller: controller,
                        child: SongItem(
                          item: ls[index - 1],
                          index: index - 1,
                          ls: ls,
                          from: 'loved',
                          listId: '',
                        ),
                      ),
                    );
                  }
                },
              ),
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