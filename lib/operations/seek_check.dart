import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class SeekCheck{

  final s=Get.put(SettingsVar());

  bool enableSeek(){
    if(s.quality.value.quality != 0 && (!s.wifi.value || !s.quality.value.cellularOnly)){
      return false;
    }
    return true;
  }
}