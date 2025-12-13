import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
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

class LanguageType{
  String name;
  Locale locale;

  LanguageType(this.name, this.locale);
}

enum ProgressStyle{
  off,
  ring,
  background,
}

List<LanguageType> get supportedLocales => [
  LanguageType("English", const Locale("en", "US")),
  LanguageType("简体中文", const Locale("zh", "CN")),
  LanguageType("繁體中文", const Locale("zh", "TW")),
];


class SettingsVar extends GetxController{

  RxBool savePlay=true.obs;
  RxBool autoLogin=true.obs;
  RxBool wifi=true.obs;
  var quality=CustomQuality().obs;
  var progressStyle=ProgressStyle.ring.obs;
  RxBool showTranslation=true.obs;

  Rx<LanguageType> lang=Rx(supportedLocales[0]);

  final bgColor1=const Color.fromARGB(255, 50, 50, 50);
  final bgColor2=const Color.fromARGB(255, 60, 60, 60);
  final bgColor3=const Color.fromARGB(255, 80, 80, 80);

  RxBool darkMode=false.obs;
  RxBool autoDark=true.obs;

  void initDark(bool? auto, bool? mode){
    autoDark.value=auto??true;
    darkMode.value=mode??false;
  }

  void autoDarkMode(bool dark){
    if(autoDark.value){
      darkMode.value=dark;
    }
  }

  late SharedPreferences prefs;

  Future<void> initLang() async {
    prefs=await SharedPreferences.getInstance();

    int? langIndex=prefs.getInt("langIndex");

    if(langIndex==null){
      final sysLang=PlatformDispatcher.instance.locale;
      // final languageCode = sysLang.split('_')[0];
      // final countryCode = sysLang.split('_').last;
      final local=Locale(sysLang.languageCode, sysLang.countryCode);
      int index=supportedLocales.indexWhere((element) => element.locale==local);
      if(index!=-1){
        lang.value=supportedLocales[index];
        lang.refresh();
      }
    }else{
      lang.value=supportedLocales[langIndex];
    }
    Get.updateLocale(lang.value.locale);
  }

  void showLanguageDialog(BuildContext context){
    Get.find<DialogVar>().showOkDialogRaw(
      context: context, 
      title: 'language'.tr, 
      child: FSelect(
        format: (s)=>supportedLocales[s].name,
        initialValue: supportedLocales.indexWhere((item)=>item.locale==lang.value.locale),
        autoHide: true,
        children: List.generate(supportedLocales.length, (int index)=> FSelectItem(
          supportedLocales[index].name,
          index,
        )),
        onChange: (value){
          if(value!=null){
            changeLanguage(value);
          }
        },
      )
    );
  }

  void changeLanguage(int index){
    lang.value=supportedLocales[index];
    prefs.setInt("langIndex", index);
    lang.refresh();
    Get.updateLocale(lang.value.locale);
  }
}
