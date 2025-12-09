import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class TitleArea extends StatefulWidget {

  // 注意将AppBar高度设置为70

  final String title;
  final String subtitle;
  final bool? showWarning;
  final VoidCallback? titleOnTap;
  final VoidCallback? subtitleOnTap;

  const TitleArea({super.key, required this.title, required this.subtitle, this.showWarning, this.titleOnTap, this.subtitleOnTap});

  @override
  State<TitleArea> createState() => _TitleAreaState();
}

class _TitleAreaState extends State<TitleArea> {

  SettingsVar s=Get.find();
  final DialogVar d=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, bottom: 0, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: GestureDetector(
                  onTap: widget.titleOnTap,
                  child: AutoSizeText(
                    widget.title,
                    maxFontSize: 35,
                    minFontSize: 25,
                    style: GoogleFonts.notoSansSc(
                      fontWeight: FontWeight.w300,
                      fontSize: 35
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: widget.subtitleOnTap,
                    child: Text(
                      widget.subtitle,
                      style: GoogleFonts.notoSansSc(
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  widget.showWarning==true ? Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: (){
                        d.showOkDialog(
                          context: context,
                          title: "songCountOverflow".tr,
                          content: "songCountOverflowContent".tr,
                          okText: "ok".tr
                        );
                      }, 
                      child: const Icon(
                        Icons.warning_rounded,
                        size: 20,
                      ),
                    )
                  ) : Container()
                ],
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchTitleArea extends StatefulWidget {

  final ValueChanged changeMode;
  final String mode;
  final bool disableMode;

  const SearchTitleArea({super.key, required this.mode, required this.changeMode, this.disableMode = false});

  @override
  State<SearchTitleArea> createState() => _SearchTitleAreaState();
}

class _SearchTitleAreaState extends State<SearchTitleArea> {

  SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, bottom: 0, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'search'.tr,
                      style: GoogleFonts.notoSansSc(
                        fontWeight: FontWeight.w300,
                        fontSize: 35
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 10,),
                    IconButton(
                      onPressed: widget.disableMode ? null : (){
                        if(widget.mode=='song'){
                          return;
                        }
                        widget.changeMode('song');
                      },
                      icon: Icon(
                        Icons.music_note_rounded,
                        color: widget.mode=='song' ? s.darkMode.value ? Colors.white : Colors.black : s.darkMode.value ? Colors.grey[500] : Colors.grey[300],
                        size: 30,
                      )
                    ),
                    IconButton(
                      onPressed: widget.disableMode ? null : (){
                        if(widget.mode=='album'){
                          return;
                        }
                        widget.changeMode('album');
                      },
                      icon: Icon(
                        Icons.album_rounded,
                        color: widget.mode=='album' ? s.darkMode.value ? Colors.white : Colors.black : s.darkMode.value ? Colors.grey[500] : Colors.grey[300],
                        size: 30,
                      )
                    ),
                    IconButton(
                      onPressed: widget.disableMode ? null : (){
                        if(widget.mode=='artist'){
                          return;
                        }
                        widget.changeMode('artist');
                      },
                      icon: Icon(
                        Icons.mic_rounded,
                        color: widget.mode=='artist' ? s.darkMode.value ? Colors.white : Colors.black : s.darkMode.value ? Colors.grey[500] : Colors.grey[300],
                        size: 30,
                      )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}