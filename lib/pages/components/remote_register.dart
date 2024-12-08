import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/variables/remote_var.dart';

class RemoteRegister extends StatefulWidget {
  const RemoteRegister({super.key});

  @override
  State<RemoteRegister> createState() => _RemoteRegisterState();
}

class _RemoteRegisterState extends State<RemoteRegister> {

  Future<void> connect(BuildContext context) async {
    urlFocus.unfocus();
    if(url.text.isEmpty){
      showOkAlertDialog(
        context: context,
        title: '连接失败',
        message: "WebSocket 地址不能为空",
        okLabel: "好的"
      );
    }else if(!url.text.startsWith('ws://')){
      showOkAlertDialog(
        context: context,
        title: '连接失败',
        message: "WebSocket 地址不合法",
        okLabel: "好的"
      );
    }
    try {
      r.socket=await WebSocket.connect(url.text).timeout(
        const Duration(seconds: 2),
      );
      await r.socket!.close();
    } catch (_) {
      r.socket=null;
    }
    if(r.socket==null && context.mounted){
      await showOkAlertDialog(
        context: context,
        title: "连接失败",
        message: "这个地址没有任何响应，检查输入的地址!",
        okLabel: "好的",
      );
      if(context.mounted){
        FocusScope.of(context).requestFocus(urlFocus);
      }
    }else{
      r.isRegister.value=true;
    }
  }

  TextEditingController url=TextEditingController();
  FocusNode urlFocus=FocusNode();
  final RemoteVar r=Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    urlFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ]
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "WebSocket 地址",
                  style: GoogleFonts.notoSansSc(
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.public),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: TextField(
                        controller: url,
                        focusNode: urlFocus,
                        decoration: InputDecoration(
                          hintText: 'ws://',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          )
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                        onEditingComplete: (){
                          connect(context);
                        },
                      )
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20,),
        SizedBox(
          width: 280,
          child: Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: (){
                  connect(context);
                },
                child: Container(
                  width: 110,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10,),
                      Text(
                        "连接",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white,
                        size: 30,
                      )
                    ],
                  )
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}