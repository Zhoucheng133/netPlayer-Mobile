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
        padding: const EdgeInsets.only(left: 30, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: AutoSizeText(
                widget.title,
                maxFontSize: 35,
                minFontSize: 20,
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
                fontSize: 16,
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