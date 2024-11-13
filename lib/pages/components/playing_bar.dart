import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/components/playbar_content.dart';
import 'package:netplayer_mobile/variables/player_var.dart';

class PlayingBar extends StatefulWidget {
  const PlayingBar({super.key});

  @override
  State<PlayingBar> createState() => _PlayingBarState();
}

class _PlayingBarState extends State<PlayingBar> {

  PlayerVar p=Get.put(PlayerVar());

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      p.switchHero.value ? const PlaybarContent() : const Hero(
        tag: 'playingbar',
        child: PlaybarContent()
      )
    );
  }
}