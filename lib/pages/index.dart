import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/components/play_view.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/pages/home.dart';
import 'package:netplayer_mobile/pages/settings.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {

  Account account=Account();
  late OverlayEntry entry;

  int pageIndex=0;

  void removeOverlay(){
    entry.remove();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      entry=OverlayEntry(
        builder: (BuildContext context) => const PlayView()
      );
      Overlay.of(context).insert(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: pageIndex==0 ? Text(
                key: const ValueKey<int>(0),
                '主页',
                style: GoogleFonts.notoSansSc(
                  fontWeight: FontWeight.w600,
                  fontSize: 22
                ),
              ) : Text(
                key: const ValueKey<int>(1),
                '设置',
                style: GoogleFonts.notoSansSc(
                  fontWeight: FontWeight.w600,
                  fontSize: 22
                ),
              )
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                const SizedBox(width: 3,),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 8,
                  width: pageIndex==0 ? 8 : 14,
                  decoration: BoxDecoration(
                    color: pageIndex==0 ? Colors.grey[800] : Colors.grey[400],
                    borderRadius: BorderRadius.circular(4)
                  ),
                ),
                const SizedBox(width: 5),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 8,
                  width: pageIndex==0 ? 14 : 8,
                  decoration: BoxDecoration(
                    color: pageIndex==0 ? Colors.grey[400] : Colors.grey[800],
                    borderRadius: BorderRadius.circular(4)
                  ),
                )
              ],
            ),
            // 测试内容
            // TextButton(
            //   onPressed: (){
            //     setState(() {
            //       titleIndex=!titleIndex;
            //     });
            //   }, 
            //   child: const Text('测试按钮')
            // )
            Expanded(
              child: Swiper(
                index: pageIndex,
                onIndexChanged: (index){
                  setState(() {
                    pageIndex=index;
                  });
                },
                itemBuilder: (BuildContext context, int index){
                  if(index==0){
                    return const Home();
                  }else{
                    return const Settings();
                  }
                },
                itemCount: 2,
                pagination: null,
                loop: false,
              )
            )
          ],
        ),
      )
    );
  }
}