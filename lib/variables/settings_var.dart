import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomQuality{
  bool cellularOnly=false;
  int quality=0;
  Map<String, dynamic> toJson() {
    return {
      'cellularOnly': cellularOnly,
      'quality': quality,
    };
  }
}

enum ProgressStyle{
  off,
  ring,
  background,
}

class SettingsVar extends GetxController{
  RxBool savePlay=true.obs;
  RxBool autoLogin=true.obs;
  RxBool wifi=true.obs;
  var quality=CustomQuality().obs;
  var progressStyle=ProgressStyle.ring.obs;

  RxBool darkMode=false.obs;
  RxBool autoDark=true.obs;

  void showDarkModeDialog(BuildContext context){

    bool tmpDarkMode=darkMode.value;
    bool tmpAutoDark=autoDark.value;

    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: const Text('深色模式'),
        content: Obx(()=>
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    '跟随系统',
                    style: GoogleFonts.notoSansSc(
                      fontSize: 16,
                    ),
                  ),
                  Expanded(child: Container()),
                  Switch(
                    activeTrackColor: Colors.blue,
                    value: autoDark.value, 
                    onChanged: (val){
                      autoDark.value=val;
                    }
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    '启用深色模式',
                    style: GoogleFonts.notoSansSc(
                      fontSize: 16,
                    ),
                  ),
                  Expanded(child: Container()),
                  Switch(
                    activeTrackColor: Colors.blue,
                    value: darkMode.value, 
                    onChanged: autoDark.value ? null : (val){
                      darkMode.value=val;
                    }
                  )
                ],
              )
            ],
          )
        ),
        actions: [
          TextButton(
            onPressed: (){
              darkMode.value=tmpDarkMode;
              autoDark.value=tmpAutoDark;
              Navigator.pop(context);
            }, 
            child: const Text('取消')
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs=await SharedPreferences.getInstance();
              prefs.setBool('autoDark', autoDark.value);
              prefs.setBool('darkMode', darkMode.value);
            }, 
            child: const Text('完成')
          )
        ],
      )
    );
  }
}
