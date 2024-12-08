import 'dart:io';

import 'package:get/get.dart';

class RemoteVar extends GetxController{
  RxString url=''.obs;
  WebSocket? socket;
  RxBool isRegister=false.obs;
}