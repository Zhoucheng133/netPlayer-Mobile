
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';

class Albums extends StatefulWidget {
  const Albums({super.key});

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
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
          TitleAria(title: '专辑', subtitle: '合计专辑'),
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