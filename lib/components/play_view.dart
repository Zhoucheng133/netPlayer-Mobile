import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/len_var.dart';

class PlayView extends StatefulWidget {
  const PlayView({super.key});

  @override
  State<PlayView> createState() => _PlayViewState();
}

class _PlayViewState extends State<PlayView> {
  
  final LenVar l = Get.put(LenVar());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        // curve: Curves.easeInOut,
        // bottom: 0,
        bottom: -MediaQuery.of(context).size.height+l.bottomLen.value+90,
        left: 0,
        right: 0,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.blue[800],
            borderRadius: BorderRadius.circular(20)
          ),
        )
      )
    );
  }
}