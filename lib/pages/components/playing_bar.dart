// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PlayingBar extends StatefulWidget {
  const PlayingBar({super.key});

  @override
  State<PlayingBar> createState() => _PlayingBarState();
}

class _PlayingBarState extends State<PlayingBar> {
  
  var tempPosition=0.0;
  void onchange(val){
    setState(() {
      tempPosition=val;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15)
        )
      ),
      height: 70+MediaQuery.of(context).padding.bottom,
      child: Container()
    );
  }
}