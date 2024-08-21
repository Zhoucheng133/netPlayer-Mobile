// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';
import 'package:netplayer_mobile/variables/page_var.dart';
import 'package:netplayer_mobile/variables/player_var.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  PlayerStatic().version,
                  style: GoogleFonts.notoSansSc(
                    fontWeight: FontWeight.w300,
                    color: Colors.grey[600],
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    final url=Uri.parse('https://github.com/Zhoucheng133/netPlayer-Next');
                    launchUrl(url);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.github,
                          size: 15,
                        ),
                        const SizedBox(width: 5,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            '本项目地址',
                            style: GoogleFonts.notoSansSc(
                              fontSize: 13,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                GestureDetector(
                  onTap: (){
                    final url=Uri.parse('https://lrclib.net/docs');
                    launchUrl(url);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.code_rounded,
                          size: 15,
                        ),
                        const SizedBox(width: 5,),
                        Text('歌词API'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 150,)
        ],
      ),
    );
  }
}