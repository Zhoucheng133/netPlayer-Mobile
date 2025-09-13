import 'package:get/get.dart';
class UserVar extends GetxController{
  RxString url=''.obs;
  RxString username=''.obs;
  RxString token=''.obs;
  RxString salt=''.obs;
  RxString password=''.obs;

  // Navidrome API认证
  RxString authorization="".obs;
  RxString uniqueId="".obs;
}