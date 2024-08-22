import 'package:get/get.dart';
class PlayerVar extends GetxController{
  RxMap<String, dynamic> nowPlay={
    'id': '',
    'title': '',
    'artist': '',
    'playFrom': '',
    'duration': 0,  // 注意这里使用的是秒~1000ms
    'fromId': '',   // 如果不适用为空
    'index': 0,
    'album': '',
    'list': [],
  }.obs;
}

class PlayerStatic{
  String version='v2.0.0';
}