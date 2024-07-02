import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/variables/variables.dart';

class Titlebar extends StatefulWidget {
  const Titlebar({super.key});

  @override
  State<Titlebar> createState() => _TitlebarState();
}

class _TitlebarState extends State<Titlebar> {

  final Variables c = Get.put(Variables());
  
  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.playPage.value ? '正在播放' : '主页',
                  style: GoogleFonts.notoSansSc(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    decoration: TextDecoration.none
                  ),
                ),
                const SizedBox(height: 5,),
                Row(
                  children: [
                    const SizedBox(width: 2,),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: c.playPage.value ? 4 : 25,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: c.playPage.value ? Colors.grey[400] : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5,),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: c.playPage.value ? 25 : 4,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: c.playPage.value ? Colors.black : Colors.grey[400],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: Colors.black
            ),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.white,
                size: 16,
              ),
            ),
          )
        ],
      )
    );
  }
}