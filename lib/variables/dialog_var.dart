import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';

class ActionItem{

  String key;
  String name;
  IconData? icon; 

  ActionItem({
    required this.key,
    required this.name,
    required this.icon,
  });
}

class DialogVar extends GetxController{
  final SettingsVar settings=Get.find();

  Future<String?> showActionSheet({
    required BuildContext context,
    required List<ActionItem> list,
  }) async {
    String? selectKey;
    await showFSheet(
      context: context, 
      mainAxisMaxRatio: 1.0,
      builder: (BuildContext context)=>Obx(()=>
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10)
            ),
            color: settings.darkMode.value ? Colors.black : Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FTileGroup(
                children: list.map((item)=>
                  FTile(
                    prefixIcon: item.icon!=null ? Icon(
                      item.icon,
                      size: 20,
                    ) : null,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(item.name, style: TextStyle(
                        fontSize: 17
                      ),),
                    ),
                    onPress: (){
                      Navigator.pop(context);
                      selectKey=item.key;
                    },
                  )
                ).toList(),
              ),
              Container(
                height: MediaQuery.of(context).padding.bottom,
                color: settings.darkMode.value ? Colors.black : Colors.white,
              )
            ],
          ),
        ),
      ),
      side: FLayout.btt,
    );
    return selectKey;
  }

  Future<void> showOkDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? okText,
    VoidCallback? okHandler,
  }) async {
    await showAdaptiveDialog(
      context: context, 
      builder: (BuildContext context)=>FDialog(
        title: Text(title, style: TextStyle(),),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(content, style: TextStyle(),),
        ),
        direction: Axis.horizontal,
        actions: [
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              if(okHandler!=null){
                okHandler();
              }
            }, 
            style: FButtonStyle.primary,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Obx(
                ()=>Text(
                  okText??'ok'.tr, 
                  style: TextStyle(
                    color: settings.darkMode.value ? Colors.black : Colors.white,
                  )
                ),
              )
            )
          ),
        ],
      )
    );
  }

  Future<void> showOkDialogRaw({
    required BuildContext context,
    required String title,
    required Widget child,
    String? okText,
    VoidCallback? okHandler,
  }) async {
    await showAdaptiveDialog(
      context: context, 
      builder: (BuildContext context)=>FDialog(
        title: Text(title, style: TextStyle(),),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: child,
        ),
        direction: Axis.horizontal,
        actions: [
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              if(okHandler!=null){
                okHandler();
              }
            }, 
            style: FButtonStyle.primary,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Obx(()=>
                Text(
                  okText??'ok'.tr, 
                  style: TextStyle(
                    color: settings.darkMode.value ? Colors.black : Colors.white,
                  )
                )
              )
            )
          ),
        ],
      )
    );
  }

  Future<void> showOkCancelDialogRaw({
    required BuildContext context,
    required String title,
    required Widget child,
    String? okText,
    String? cancelText,
    required VoidCallback okHandler,
    VoidCallback? cancelHandler,
  }) async {
    await showAdaptiveDialog(
      context: context, 
      builder: (BuildContext context)=>FDialog(
        title: Text(title, style: TextStyle(),),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: child,
        ),
        direction: Axis.horizontal,
        actions: [
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              if(cancelHandler!=null){
                cancelHandler();
              }
            }, 
            style: FButtonStyle.outline,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Obx(()=>
                Text(
                  cancelText??'cancel'.tr, 
                  style: TextStyle(
                    color: settings.darkMode.value ? Colors.white : Colors.black,
                  )
                )
              )
            )
          ),
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              okHandler();
            }, 
            style: FButtonStyle.primary,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Obx(()=>
                Text(
                  okText??'continue'.tr, 
                  style: TextStyle(
                    color: settings.darkMode.value ? Colors.black : Colors.white,
                  )
                )
              )
            )
          ),
        ],
      )
    );
  }

  Future<bool> showOkCancelDialog({
    required BuildContext context,
    required String title,
    required String content,
    String? okText,
    String? cancelText
  }) async {
    bool data=false;
    await showAdaptiveDialog(
      context: context, 
      builder: (BuildContext context)=>FDialog(
        direction: Axis.horizontal,
        title: Text(title, style: TextStyle(),),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(content, style: TextStyle(),),
        ),
        actions: [
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              data=false;
            }, 
            style: FButtonStyle.outline,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Obx(()=>
                Text(
                  cancelText??'cancel'.tr, 
                  style: TextStyle(
                    color: settings.darkMode.value ? Colors.white : Colors.black,
                  )
                )
              )
            )
          ),
          FButton.raw(
            onPress: (){
              Navigator.pop(context);
              data=true;
            }, 
            style: FButtonStyle.primary,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 14, right: 14),
              child: Obx(()=>
                Text(
                  okText??'continue'.tr, 
                  style: TextStyle(
                    color: settings.darkMode.value ? Colors.black : Colors.white,
                  )
                )
              )
            )
          ),
        ],
      )
    );
    return data;
  }
}