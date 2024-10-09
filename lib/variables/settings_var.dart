import 'package:get/get.dart';

class CustomQuality{
  bool cellularOnly=false;
  int quality=0;
}

class SettingsVar extends GetxController{
  RxBool savePlay=true.obs;
  RxBool autoLogin=true.obs;
  RxBool wifi=true.obs;
  var quality=CustomQuality().obs;
}
