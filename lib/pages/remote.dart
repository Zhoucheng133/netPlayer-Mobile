import 'package:flutter/material.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';

class Remote extends StatefulWidget {
  const Remote({super.key});

  @override
  State<Remote> createState() => _RemoteState();
}

class _RemoteState extends State<Remote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        centerTitle: false,
      ),
      body: const Column(
        children: [
          TitleAria(title: '远程控制', subtitle: '',),
        ],
      ),
    );
  }
}