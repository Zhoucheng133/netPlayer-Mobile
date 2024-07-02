import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/variables.dart';
import 'package:netplayer_mobile/views/components/playbar.dart';
import 'package:netplayer_mobile/views/components/titlebar.dart';
import 'package:netplayer_mobile/views/pages/home_page.dart';
import 'package:netplayer_mobile/views/pages/play_page.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final Variables c = Get.put(Variables());

  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
    });
  }

  @override
  void dispose() {
    _overlayEntry.remove();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => PlayBar()
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 0),
          child: Column(
            children: [
              Titlebar(),
              const SizedBox(height: 10,),
              Expanded(
                child: Swiper(
                  itemCount: 2,
                  loop: false,
                  pagination: null,
                  control: null,
                  onIndexChanged: (index){
                    if(index==0){
                      c.playPage.value=false;
                      c.showPlayBar.value=true;
                    }else{
                      c.playPage.value=true;
                      c.showPlayBar.value=false;
                    }
                  },
                  itemBuilder: (BuildContext context, int index){
                    if(index==0){
                      return HomePage();
                    }
                    return PlayPage();
                  },
                )
              )
            ],
          ),
        )
      )
    );
  }
}