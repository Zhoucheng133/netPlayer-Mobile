import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Localdialog{
  Future<void> showLocalDialog(BuildContext context, String title, String content) async {
    if(Platform.isIOS){
      await showCupertinoDialog(
        context: context, 
        builder: (BuildContext context)=>CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: Text('好的'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        )
      );
    }else{
      await showDialog(
        context: context, 
        builder: (BuildContext context)=>AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('好的')
            )
          ],
        )
      );
    }
  }
}