// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';

class Loved extends StatefulWidget {
  const Loved({super.key});

  @override
  State<Loved> createState() => _LovedState();
}

class _LovedState extends State<Loved> {
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
          TitleAria(title: '喜欢的歌曲', subtitle: '合计歌曲'),
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