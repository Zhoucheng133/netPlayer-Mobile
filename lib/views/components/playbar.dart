import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/variables.dart';

class PlayBar extends StatefulWidget {
  const PlayBar({super.key});

  @override
  State<PlayBar> createState() => _PlayBarState();
}

class _PlayBarState extends State<PlayBar> {

  final Variables c = Get.put(Variables());
  
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      AnimatedPositioned(
        bottom: c.showPlayBar.value ? 10+MediaQuery.of(context).padding.bottom : -80,
        left: 10,
        right: 10,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40)
          ),
        ),
      )
    );
  }
}