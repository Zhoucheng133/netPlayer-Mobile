// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';

class Playlist extends StatefulWidget {

  final String id;

  const Playlist({super.key, required this.id});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
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
          TitleAria(title: '歌单', subtitle: '合计歌曲'),
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