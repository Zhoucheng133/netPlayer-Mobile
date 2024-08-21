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
            Text(
              widget.title,
              style: GoogleFonts.notoSansSc(
                fontSize: 35,
                fontWeight: FontWeight.w300,
                color: Colors.black
              ),
            ),
            const SizedBox(height: 20,),
            Text(
              widget.subtitle,
              style: GoogleFonts.notoSansSc(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}