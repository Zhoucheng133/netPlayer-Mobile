import 'package:flutter/cupertino.dart' show CupertinoScrollbar;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/components/queue_item.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PlayQueue extends StatefulWidget {
  const PlayQueue({super.key});

  @override
  State<PlayQueue> createState() => _PlayQueueState();
}

class _PlayQueueState extends State<PlayQueue> {

  final PlayerVar p=Get.find();
  AutoScrollController controller=AutoScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final maxScroll = controller.position.maxScrollExtent;
      double targetOffset = (50 * p.nowPlay['index'] - 50 * 3).toDouble();
      targetOffset = targetOffset.clamp(0.0, maxScroll);
      controller.jumpTo(targetOffset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom+10, top: 15),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'nowPlayList'.tr,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){
                    controller.scrollToIndex(p.nowPlay['index'], preferPosition: AutoScrollPosition.middle);
                  }, 
                  icon: const Icon(
                    Icons.my_location_rounded,
                    size: 22,
                  )
                )
              ],
            ),
          ),
          const SizedBox(height: 15,),
          Expanded(
            child: Obx(()=>
              CupertinoScrollbar(
                controller: controller,
                child: ListView.builder(
                  controller: controller,
                  itemCount: p.nowPlay['list'].length,
                  itemBuilder: (context, index)=>AutoScrollTag(
                    key: ValueKey(index),
                    controller: controller,
                    index: index,
                    child: QueueItem(songItem: p.nowPlay['list'][index], index: index,)
                  )
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}