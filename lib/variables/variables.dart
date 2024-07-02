import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Variables extends GetxController{

  // 用户登录信息
  RxBool isLogin=false.obs;
  RxString username=''.obs;
  RxString url=''.obs;
  RxString salt=''.obs;
  RxString token=''.obs;

  // 当前页面
  RxBool playPage=false.obs;

  // 显示播放栏
  RxBool showPlayBar=true.obs;

  // 颜色，从浅色->深色
  var color1=Color.fromARGB(255, 1, 87, 155);
  var color2=Color.fromARGB(255, 2, 119, 189);
  var color3=Color.fromARGB(255, 2, 136, 209);
  var color4=Color.fromARGB(255, 3, 155, 229);
  var color5=Color.fromARGB(255, 3, 169, 244);
  var color6=Color.fromARGB(255, 41, 182, 246);
  var color7=Color.fromARGB(255, 79, 195, 247);
  var color8=Color.fromARGB(255, 129, 212, 250);
  var color9=Color.fromARGB(255, 179, 229, 252);
  var color10=Color.fromARGB(255, 235, 249, 255);
}