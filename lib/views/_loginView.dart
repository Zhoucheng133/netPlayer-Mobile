// ignore_for_file: file_names, camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/functions/requests.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class loginView extends StatefulWidget {
  const loginView({super.key});

  @override
  State<loginView> createState() => _loginViewState();
}

class _loginViewState extends State<loginView> {
  final Controller c = Get.put(Controller());

  var urlInput=TextEditingController();
  var usernameInput=TextEditingController();
  var passwordInput=TextEditingController();

  var tapLogin=false;

  void _showDialog(BuildContext context, String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future<void> loginController(context) async {
    if(urlInput.text==""){
      _showDialog(context, "登录失败", "没有输入URL地址");
      return;
    }else if(usernameInput.text==""){
      _showDialog(context, "登录失败", "没有输入用户名");
      return;
    }else if(passwordInput.text==""){
      _showDialog(context, "登录失败", "没有输入密码");
      return;
    }
    Map resp=await loginRequest(urlInput.text, usernameInput.text, passwordInput.text);
    if(resp["status"]=="failed"){
      _showDialog(context, "登录失败", "密码错误");
    }else if(resp["status"]=="URL Err"){
      _showDialog(context, "登录失败", "URL请求错误");
    }else{
      Map userInfo={
        "url": resp["url"].toString(),
        "username": resp["username"].toString(),
        "salt": resp["salt"].toString(),
        "token": resp["token"].toString(),
      };
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String info=json.encode(userInfo);
      await prefs.setString('userInfo', info);
      c.updatePlayInfo(userInfo);
      c.updateLogin(true);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "登录到你的音乐服务器",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 50),
            child: Text(
              "输入你的音乐服务器信息来登录",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
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
                    "服务器的URL地址",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.public),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextField(
                          controller: urlInput,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        )
                      )
                    ],
                  ),
                ],
              ),
            )
          ),
          SizedBox(height: 20,),
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
                    "用户名",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextField(
                          controller: usernameInput,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        )
                      )
                    ],
                  ),
                ],
              ),
            )
          ),
          SizedBox(height: 20,),
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
                    "密码",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.key),
                      SizedBox(width: 5,),
                      Expanded(
                        child: TextField(
                          controller: passwordInput,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        )
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30,),
          SizedBox(
            width: 280,
            child: Row(
              children: [
                Expanded(child: Container()),
                GestureDetector(
                  onTap: ()async{
                    loginController(context);
                  },
                  onTapUp: (details){
                    setState(() {
                      tapLogin=false;
                    });
                  },
                  onTapDown: (detail){
                    setState(() {
                      tapLogin=true;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 110,
                    height: 50,
                    decoration: BoxDecoration(
                      color: tapLogin ? c.mainColorStrang : c.mainColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 10,),
                        Text(
                          "登录",
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}