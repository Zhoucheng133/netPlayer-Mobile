// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
      ),
      body: Column(
        children: [
          const TitleAria(title: '关于', subtitle: ' '),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/icon.png")
                    )
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  'netPlayer Mobile',
                  style: GoogleFonts.notoSansSc(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  'v2.0.0',
                  style: GoogleFonts.notoSansSc(
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 200,)
        ],
      ),
    );
  }
}