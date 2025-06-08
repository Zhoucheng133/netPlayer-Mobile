import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/remote_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteContent extends StatefulWidget {
  const RemoteContent({super.key});

  @override
  State<RemoteContent> createState() => _RemoteContentState();
}

class _RemoteContentState extends State<RemoteContent> {

  final RemoteVar r=Get.find();
  late SharedPreferences prefs;
  AutoScrollController controller=AutoScrollController();

  void listener(){
    final command=json.encode({
      "command": 'get',
    });
    r.socket!.add(command);
    r.socket!.listen((message){
      final msg=json.decode(message);
      r.wsData.value.updateAll(msg['title'], msg['artist'], msg['cover'], msg['line'], msg['fullLyric'],  msg['isPlay'], msg['mode'], msg['lyric']);
      r.wsData.refresh();
      scrollLyric();
    });
  }

  Future<void> init() async {
    prefs=await SharedPreferences.getInstance();
    final url=prefs.getString('remote');
    if(url!=null && url.startsWith("ws://")){
      try {
        r.socket=await WebSocket.connect(url).timeout(
          const Duration(seconds: 2),
        );
        listener();
      } catch (_) {
        r.isRegister.value=false;
        r.socket=null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  bool playedLyric(int line){
    if(r.wsData.value.fullLyric.length==1){
      return true;
    }
    return line==r.wsData.value.line-1;
  }

  void scrollLyric(){
    if(r.wsData.value.line==0){
      return;
    }
    controller.scrollToIndex(r.wsData.value.line-1, preferPosition: AutoScrollPosition.middle);
  }

  void skipForward(){
    final command=json.encode({
      "command": "forw"
    });
    try {
      r.socket!.add(command);
    } catch (_) {}
  }
  
  void toggle(){
    final command=json.encode({
      "command": r.wsData.value.isPlay ? 'pause': 'play'
    });
    try {
      r.socket!.add(command);
    } catch (_) {}
    r.wsData.value.isPlay=!r.wsData.value.isPlay;
    r.wsData.refresh();
  }

  void skipNext(){
    final command=json.encode({
      "command": "skip"
    });
    try {
      r.socket!.add(command);
    } catch (_) {}
  }

  SettingsVar s=Get.find();
  final DialogVar d=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: r.wsData.value.cover.startsWith("http") ? Image.network(r.wsData.value.cover, width: 70, height: 70,) : Image.asset('assets/blank.jpg', width: 70, height: 70,)
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.wsData.value.title,
                        style: GoogleFonts.notoSansSc(
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        r.wsData.value.artist,
                        style: GoogleFonts.notoSansSc(
                          color: Colors.grey[500]
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: '关闭连接',
                  onPressed: () async {
                    final rlt=await d.showOkCancelDialog(
                      context: context,
                      title: "关闭连接",
                      content: "这会回到连接页面",
                      okText: "继续",
                      cancelText: "取消"
                    );
                    if(rlt){
                      try {
                        r.socket!.close();
                        r.url.value="";
                        prefs.remove('remote');
                        r.isRegister.value=false;
                      } catch (_) {}
                    }
                  }, 
                  icon: const FaIcon(
                    FontAwesomeIcons.rightFromBracket,
                    size: 20,
                  )
                )
              ]
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double topBottomHeight = constraints.maxHeight / 2;
                  return Align(
                    alignment: Alignment.center,
                    child: ListView.builder(
                      controller: controller,
                      itemCount: r.wsData.value.fullLyric.length,
                      itemBuilder: (context, index)=>Column(
                        children: [
                          index==0 ?  SizedBox(height: topBottomHeight-10,) :Container(),
                          Obx(() => 
                            AutoScrollTag(
                              key: ValueKey(index), 
                              controller: controller, 
                              index: index,
                              // child: Text(
                              //   r.wsData.value.fullLyric[index]['lyric'],
                              //   textAlign: TextAlign.center,
                              //   style: GoogleFonts.notoSansSc(
                              //     fontSize: 18,
                              //     height: 2.5,
                              //     color: playedLyric(index) ? Colors.blue:Colors.grey[400],
                              //     fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                              //   ),
                              // ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 7),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      r.wsData.value.fullLyric[index]['lyric'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoSansSc(
                                        fontSize: 17,
                                        color: playedLyric(index) ? Colors.blue:Colors.grey[400],
                                        fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                                      ),
                                    ),
                                    if(r.wsData.value.fullLyric[index]['translate'].isNotEmpty) Text(
                                      r.wsData.value.fullLyric[index]['translate'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoSansSc(
                                        fontSize: 17*0.85,
                                        color: playedLyric(index) ? Colors.blue:Colors.grey[400],
                                        fontWeight: playedLyric(index) ? FontWeight.bold: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ),
                          index==r.wsData.value.fullLyric.length-1 ? SizedBox(height: topBottomHeight-10,) : Container(),
                        ],
                      ),
                    )
                  );
                }
              ),
            )
          ),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: ()=>skipForward(),
                  icon: const Icon(
                    Icons.skip_previous_rounded,
                    size:30,
                  ),
                ),
                const SizedBox(width: 15,),
                GestureDetector(
                  onTap: ()=>toggle(),
                  child: AnimatedContainer(
                    height: 60,
                    width: 60,
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: s.darkMode.value ? s.bgColor3 : Colors.white,
                      border: Border.all(
                        color: s.darkMode.value ? Colors.white : Colors.black,
                        width: 3
                      )
                    ),
                    child: Icon(
                      r.wsData.value.isPlay ? Icons.pause_rounded : Icons.play_arrow_rounded
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
                IconButton(
                  onPressed: ()=>skipNext(),
                  icon: const Icon(
                    Icons.skip_next_rounded,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
            height: MediaQuery.of(context).padding.bottom,
            width: double.infinity,
          )
        ],
      )
    );
  }
}