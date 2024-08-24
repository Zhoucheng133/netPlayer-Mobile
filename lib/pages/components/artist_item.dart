import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/pages/artist_content.dart';

class ArtistItem extends StatefulWidget {
  // 调用时注意左右Padding 10

  final int index;
  final dynamic item;

  const ArtistItem({super.key, required this.index, required this.item});

  @override
  State<ArtistItem> createState() => _ArtistItemState();
}

class _ArtistItemState extends State<ArtistItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>ArtistContent(id: widget.item['id'], artist: widget.item['name']));
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
                    widget.item['name'],
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansSc(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${widget.item['albumCount']}张专辑",
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
      )
    );
  }
}