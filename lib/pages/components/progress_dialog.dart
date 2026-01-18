import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> showProgressDialog(BuildContext context) async {
  SettingsVar s=Get.find();
  DialogVar d=Get.find();
  final List<String> types=[
    'close'.tr,
    'ring'.tr,
    'background'.tr,
  ];

  var style=s.progressStyle.value.index;

  // final controller = FRadioSelectGroupController(value: style);

  await d.showOkCancelDialogRaw(
    context: context, 
    title: 'progressbarStyle'.tr, 
    child: StatefulBuilder(
      builder: (context, _) {
        return FSelect<int>.rich(
          control: .managed(initial: s.progressStyle.value.index, onChange: (value){
            if(value!=null){
              style=value;
            }
          }), autoHide: true,
          format: (int s)=>types[s],
          children: List.generate(types.length, (int index) {
            return FSelectItem<int>(
              title: Text(types[index]),
              value: index
            );
          }),
        );
      }
    ),
    cancelText: "cancel".tr,
    okText: 'ok'.tr,
    okHandler: () async {
      s.progressStyle.value=ProgressStyle.values[style];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('progressStyle', style);
    }
  );
}