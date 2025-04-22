import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class DialogVar extends GetxController{
  final SettingsVar settings=Get.find();

  Future<void> showOkDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? okText,
    VoidCallback? okHandler,
  }) async {
    await showAdaptiveDialog(
      context: context, 
      builder: (BuildContext context)=>FDialog(
        title: Text(title, style: GoogleFonts.notoSansSc(),),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(content, style: GoogleFonts.notoSansSc(),),
        ),
        direction: Axis.horizontal,
        actions: [
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              if(okHandler!=null){
                okHandler();
              }
            }, 
            style: FButtonStyle.primary,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Text(okText??'完成', style: GoogleFonts.notoSansSc(
                color: settings.darkMode.value ? Colors.black : Colors.white,
              ))
            )
          ),
        ],
      )
    );
  }

  Future<void> showOkDialogRaw({
    required BuildContext context,
    required String title,
    required Widget child,
    String? okText,
    VoidCallback? okHandler,
  }) async {
    await showAdaptiveDialog(
      context: context, 
      builder: (BuildContext context)=>FDialog(
        title: Text(title, style: GoogleFonts.notoSansSc(),),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: child,
        ),
        direction: Axis.horizontal,
        actions: [
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              if(okHandler!=null){
                okHandler();
              }
            }, 
            style: FButtonStyle.primary,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Text(okText??'完成', style: GoogleFonts.notoSansSc(
                color: settings.darkMode.value ? Colors.black : Colors.white,
              ))
            )
          ),
        ],
      )
    );
  }

  Future<void> showOkCancelDialogRaw({
    required BuildContext context,
    required String title,
    required Widget child,
    String? okText,
    String? cancelText,
    required VoidCallback okHandler,
    VoidCallback? cancelHandler,
  }) async {
    await showAdaptiveDialog(
      context: context, 
      builder: (BuildContext context)=>FDialog(
        title: Text(title, style: GoogleFonts.notoSansSc(),),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: child,
        ),
        direction: Axis.horizontal,
        actions: [
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              if(cancelHandler!=null){
                cancelHandler();
              }
            }, 
            style: FButtonStyle.outline,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Text(cancelText??'取消', style: GoogleFonts.notoSansSc(
                color: settings.darkMode.value ? Colors.white : Colors.black,
              ))
            )
          ),
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              okHandler();
            }, 
            style: FButtonStyle.primary,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Text(okText??'继续', style: GoogleFonts.notoSansSc(
                color: settings.darkMode.value ? Colors.black : Colors.white,
              ))
            )
          ),
        ],
      )
    );
  }

  Future<bool> showOkCancelDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? okText,
    String? cancelText
  }) async {
    bool data=false;
    await showAdaptiveDialog(
      context: context, 
      builder: (BuildContext context)=>FDialog(
        direction: Axis.horizontal,
        title: Text(title, style: GoogleFonts.notoSansSc(),),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(content, style: GoogleFonts.notoSansSc(),),
        ),
        actions: [
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              data=false;
            }, 
            style: FButtonStyle.outline,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Text(cancelText??'取消', style: GoogleFonts.notoSansSc(
                color: settings.darkMode.value ? Colors.white : Colors.black,
              ))
            )
          ),
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              data=true;
            }, 
            style: FButtonStyle.primary,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Text(okText??'继续', style: GoogleFonts.notoSansSc(
                color: settings.darkMode.value ? Colors.black : Colors.white,
              ))
            )
          ),
        ],
      )
    );
    return data;
  }
}