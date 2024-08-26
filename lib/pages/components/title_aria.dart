import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleAria extends StatefulWidget {

  // 注意将AppBar高度设置为70

  final String title;
  final String subtitle;

  const TitleAria({super.key, required this.title, required this.subtitle});

  @override
  State<TitleAria> createState() => _TitleAriaState();
}

class _TitleAriaState extends State<TitleAria> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100]
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 0, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: AutoSizeText(
                widget.title,
                maxFontSize: 35,
                minFontSize: 25,
                style: GoogleFonts.notoSansSc(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 35
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              widget.subtitle,
              style: GoogleFonts.notoSansSc(
                fontSize: 14,
                color: Colors.black,
              ),
              overflow: TextOverflow.fade,
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}

class SearchTitleArea extends StatefulWidget {

  final ValueChanged changeMode;
  final String mode;

  const SearchTitleArea({super.key, required this.mode, required this.changeMode});

  @override
  State<SearchTitleArea> createState() => _SearchTitleAreaState();
}

class _SearchTitleAreaState extends State<SearchTitleArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100]
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 0, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '搜索',
                    style: GoogleFonts.notoSansSc(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 35
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 10,),
                  IconButton(
                    onPressed: (){
                      if(widget.mode=='song'){
                        return;
                      }
                      widget.changeMode('song');
                    },
                    icon: Icon(
                      Icons.music_note_rounded,
                      color: widget.mode=='song' ? Colors.black : Colors.grey[300],
                      size: 30,
                    )
                  ),
                  IconButton(
                    onPressed: (){
                      if(widget.mode=='album'){
                        return;
                      }
                      widget.changeMode('album');
                    },
                    icon: Icon(
                      Icons.album_rounded,
                      color: widget.mode=='album' ? Colors.black : Colors.grey[300],
                      size: 30,
                    )
                  ),
                  IconButton(
                    onPressed: (){
                      if(widget.mode=='artist'){
                        return;
                      }
                      widget.changeMode('artist');
                    },
                    icon: Icon(
                      Icons.mic_rounded,
                      color: widget.mode=='artist' ? Colors.black : Colors.grey[300],
                      size: 30,
                    )
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}