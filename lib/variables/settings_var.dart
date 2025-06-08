import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  RxBool showTranslation=true.obs;

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
}
