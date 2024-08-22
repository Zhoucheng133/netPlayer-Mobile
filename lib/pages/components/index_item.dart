// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/pages/playlist.dart';
import 'package:netplayer_mobile/variables/user_var.dart';

class MenuItem extends StatefulWidget {

  final bool isSet;
  final String name;
  final VoidCallback func;

  const MenuItem({super.key, required this.isSet, required this.name, required this.func});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.func();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.name,
            style: GoogleFonts.notoSansSc(
              fontSize: 16,
              color: widget.isSet ? Colors.black : Colors.grey[500],
            ),
          ),
          SizedBox(height: 5,),
          AnimatedOpacity(
            opacity: widget.isSet ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2)
              ),
            ),
          )
        ],
      ),
    );
  }
}

class IndexPinItem extends StatefulWidget {

  final IconData icon;
  final String label;
  final Color bgColor;
  final Color contentColor;
  final VoidCallback func;

  const IndexPinItem({super.key, required this.icon, required this.label, required this.bgColor, required this.contentColor, required this.func});

  @override
  State<IndexPinItem> createState() => _IndexPinItemState();
}

class _IndexPinItemState extends State<IndexPinItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.func();
      },
      child: Container(
        height: 200,
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.bgColor,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Icon(
                  widget.icon,
                  size: 30,
                  color: widget.contentColor,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(80)
                ),
                child: Center(
                  child: Text(
                    widget.label,
                    style: GoogleFonts.notoSansSc(
                      color: widget.contentColor,
                      fontSize: 15
                    ),
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

class PlayListItem extends StatefulWidget {

  final String name;
  final String id;
  final int songCount;
  final String coverArt;

  const PlayListItem({super.key, required this.name, required this.id, required this.songCount, required this.coverArt});

  @override
  State<PlayListItem> createState() => _PlayListItemState();
}

class _PlayListItemState extends State<PlayListItem> {

  final UserVar u = Get.put(UserVar());
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              image: DecorationImage(
                image: NetworkImage(
                  '${u.url.value}/rest/getCoverArt.view?u=${u.username.value}&t=${u.token.value}&s=${u.salt.value}&v=1.16.1&c=netPlayer&f=json&id=${widget.coverArt}',
                ),
                fit: BoxFit.cover,
              )
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: GestureDetector(
              onTap: (){
                Get.to(()=>Playlist(id: widget.id));
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text("${widget.songCount}首")
                  ],
                ),
              ),
            )
          ),
          GestureDetector(
            onTap: (){
              // TODO 歌单操作
            },
            child: Icon(Icons.more_vert_rounded)
          )
        ],
      ),
    );
  }
}