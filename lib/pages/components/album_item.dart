import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/pages/album_content.dart';

class AlbumItem extends StatefulWidget {

  final int index;
  final dynamic item;

  const AlbumItem({super.key, required this.index, required this.item});

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(() =>AlbumContent(album: widget.item['title'], id: widget.item['id']));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          color: Colors.transparent,
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 30,
                child: Center(
                  child: Text((widget.index+1).toString())
                ),
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
                      "${widget.item['songCount']}首歌曲",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 12,
                        color:Colors.grey[400]
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}