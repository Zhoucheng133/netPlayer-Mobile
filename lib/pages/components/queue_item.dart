import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/player_control.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class QueueItem extends StatefulWidget {

  final dynamic songItem;
  final int index;

  const QueueItem({super.key, this.songItem, required this.index});

  @override
  State<QueueItem> createState() => _QueueItemState();
}

class _QueueItemState extends State<QueueItem> {

  final PlayerVar p=Get.find();
  final SettingsVar s=Get.find();

  bool playing(){
    return p.nowPlay['index']==widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        PlayerControl().playSong(context, widget.songItem['id'], widget.songItem['title'], widget.songItem['artist'], p.nowPlay['playFrom'], widget.songItem['duration'], p.nowPlay['fromId'], widget.index, p.nowPlay['list'], widget.songItem['album']);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          color: Colors.transparent,
          height: 50,
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
                        widget.songItem['title'],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 16,
                          fontWeight: playing() ? FontWeight.bold : FontWeight.normal,
                          color: playing() ? Colors.blue : s.darkMode.value ? Colors.white : Colors.black
                        ),
                      ),
                      Text(
                        widget.songItem['artist'],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 12,
                          color: playing() ? Colors.blue : Colors.grey[400]
                        ),
                      )
                    ],
                  ),
                )
              ),
            ],
          ),
        )
      )
    );
  }
}