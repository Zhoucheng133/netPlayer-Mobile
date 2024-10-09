import 'package:get/get.dart';

interface class CustomQuality{
  bool cellularOnly=false;
  int quality=0;
}

class SettingsVar extends GetxController{
  RxBool savePlay=true.obs;
  RxBool autoLogin=true.obs;
  var quality=CustomQuality().obs;
}
