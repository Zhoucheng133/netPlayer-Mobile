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
}
