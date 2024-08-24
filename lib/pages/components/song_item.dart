import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/player_control.dart';
import 'package:netplayer_mobile/variables/ls_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';

class SongItem extends StatefulWidget {
  // 调用时注意左右Padding 10

  final dynamic item;
  final int index;
  final List ls;
  final String from;
  final String listId;

  const SongItem({super.key, required this.item, required this.index, required this.ls, required this.from, required this.listId});

  @override
  State<SongItem> createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {

  PlayerVar p=Get.put(PlayerVar());
  LsVar l=Get.put(LsVar());

  bool playing(){
    if(p.nowPlay['fromId']==widget.listId && p.nowPlay['playFrom']==widget.from && p.nowPlay['index']==widget.index){
      return true;
    }
    return false;
  }

  bool isLoved(){
    for (var val in l.loved) {
      if(val["id"]==widget.item['id']){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        PlayerControl().playSong(context, widget.item['id'], widget.item['title'], widget.item['artist'], widget.from, widget.item['duration'], widget.listId, widget.index, widget.ls, widget.item['album']);
      },
      child: Container(
        color: Colors.transparent,
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
              child: Center(
                child: Obx(()=>
                  playing() ? const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.blue,
                  ) : Text((widget.index+1).toString())
                )
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Obx(()=>
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item['title'],
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 16,
                        fontWeight: playing() ? FontWeight.bold : FontWeight.normal,
                        color: playing() ? Colors.blue : Colors.black
                      ),
                    ),
                    Row(
                      children: [
                        isLoved() ? const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: Colors.red,
                            size: 15,
                          ),
                        ) : Container(),
                        Expanded(
                          child: Text(
                            widget.item['artist'],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSansSc(
                              fontSize: 12,
                              color: playing() ? Colors.blue : Colors.grey[400]
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ),
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: () async {
                var req=await showModalActionSheet(
                  title: "更多操作",
                  context: context,
                  actions: [
                    const SheetAction(label: '添加到歌单...', key: "lyric", icon: Icons.playlist_add_rounded),
                    isLoved() ? const SheetAction(label: '取消喜欢', key: 'delove', icon: Icons.heart_broken_rounded) : 
                    const SheetAction(label: '添加到喜欢', key: "love", icon: Icons.favorite_rounded),
                    const SheetAction(label: "查看这个专辑", key: "album", icon: Icons.album_rounded),
                    const SheetAction(label: "查看这个艺人", key: "artist", icon: Icons.mic_rounded),
                    if(widget.listId.isNotEmpty) const SheetAction(label: "从歌单中移除", key: "delist", icon: Icons.playlist_remove_rounded, ),
                  ]
                );
                // TODO 更多操作
                print(req);
              },
              child: Container(
                color: Colors.transparent,
                width: 50,
                child: Center(
                  child: Obx(()=>
                    Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: playing() ? Colors.blue : Colors.grey[400]
                    ),
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}