import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/player_control.dart';

class SongItem extends StatefulWidget {
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
              child: Center(child: Text((widget.index+1).toString())),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item['title'],
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansSc(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.item['artist'],
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansSc(
                      fontSize: 12,
                      color: Colors.grey[400]
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: (){
                print("详细~~");
                // TODO 歌曲详细
              },
              child: Container(
                color: Colors.transparent,
                width: 50,
                child: const Center(
                  child: Icon(
                    Icons.more_vert_rounded,
                    size: 20,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}