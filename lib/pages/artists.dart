
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';

class Artists extends StatefulWidget {
  const Artists({super.key});

  @override
  State<Artists> createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
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
          TitleAria(title: '艺人', subtitle: '合计艺人'),
          Expanded(
            child: Container(),
          ),
          Hero(
            tag: 'playingbar', 
            child: PlayingBar()
          )
        ],
      ),
    );
  }
}