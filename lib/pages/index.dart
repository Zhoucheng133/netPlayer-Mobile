import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/components/play_view.dart';
import 'package:netplayer_mobile/operations/account.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {

  Account account=Account();
  late OverlayEntry entry;

  bool titleIndex=true;

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
        padding: const EdgeInsets.only(bottom: 90, left: 20, right: 20),
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: titleIndex ? Text(
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
            FilledButton(
              onPressed: (){
                if(titleIndex){
                  setState(() {
                    titleIndex=false;
                  });
                }else{
                  setState(() {
                    titleIndex=true;
                  });
                }
              }, 
              child: const Text('切换')
            )
          ],
        ),
      )
    );
  }
}