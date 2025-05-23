import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/variables/dialog_var.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:netplayer_mobile/variables/user_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final UserVar u = Get.find();
  Account account=Account();
  final DialogVar d=Get.find();

  var urlInput=TextEditingController();
  var usernameInput=TextEditingController();
  var passwordInput=TextEditingController();

  FocusNode urlFocus=FocusNode();
  FocusNode usernameFocus=FocusNode();
  FocusNode passwordFocus=FocusNode();


  @override
  void dispose() {
    urlFocus.dispose();
    usernameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }


  Future<void> loginController(BuildContext context) async {
    if(urlInput.text.isEmpty){
      d.showOkDialog(
        context: context,
        title: '登录失败',
        content: '没有输入URL地址',
        okText: '好的'
      );
    }else if(usernameInput.text.isEmpty){
      d.showOkDialog(
        context: context,
        title: '登录失败',
        content: '没有输入用户名',
        okText: '好的'
      );
    }else if(passwordInput.text.isEmpty){
      d.showOkDialog(
        context: context,
        title: '登录失败',
        content: '没有输入密码',
        okText: '好的'
      );
    }else if(!urlInput.text.startsWith('http://') && !urlInput.text.startsWith('https://')){
      d.showOkDialog(
        context: context,
        title: '登录失败',
        content: 'URL地址不合法',
        okText: '好的'
      );
    }else{
      var salt=account.generateRandomString(6);
      var bytes = utf8.encode(passwordInput.text+salt);
      var token = md5.convert(bytes);
      var resp=await account.login(urlInput.text, usernameInput.text, token.toString(), salt);
      if(resp['ok']){
        u.username.value=usernameInput.text;
        u.salt.value=salt;
        u.url.value=urlInput.text;
        u.token.value=token.toString();
        SharedPreferences prefs=await SharedPreferences.getInstance();
        prefs.setString('url', urlInput.text);
        prefs.setString('username', usernameInput.text);
        prefs.setString('token', token.toString());
        prefs.setString('salt', salt);
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          d.showOkDialog(
            context: context,
            title: '登录失败',
            content: resp['data'],
            okText: '好的'
          );
        });
      }
    }
  }

  SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(()=>
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "登录到你的音乐服务器",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 50),
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
                color: s.darkMode.value ? s.bgColor3 : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    // color: Colors.grey.withOpacity(0.1),
                    color: Colors.grey.withAlpha(2),
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
                            controller: urlInput,
                            focusNode: urlFocus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'http(s)://',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                              )
                            ),
                            autocorrect: false,
                            // enableSuggestions: false,
                            onEditingComplete: (){
                              try {
                                FocusScope.of(context).requestFocus(usernameFocus);
                              } catch (_) {}
                            },
                          )
                        )
                      ],
                    ),
                  ],
                ),
              )
            ),
            const SizedBox(height: 20,),
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: s.darkMode.value ? s.bgColor3 : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    // color: Colors.grey.withOpacity(0.1),
                    color: Colors.grey.withAlpha(2),
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
                      style: GoogleFonts.notoSansSc(
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: TextField(
                            controller: usernameInput,
                            focusNode: usernameFocus,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            autocorrect: false,
                            // enableSuggestions: false,
                            onEditingComplete: (){
                              try {
                                FocusScope.of(context).requestFocus(passwordFocus);
                              } catch (_) {}
                            },
                          )
                        )
                      ],
                    ),
                  ],
                ),
              )
            ),
            const SizedBox(height: 20,),
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: s.darkMode.value ? s.bgColor3 : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    // color: Colors.grey.withOpacity(0.1),
                    color: Colors.grey.withAlpha(2),
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
                      style: GoogleFonts.notoSansSc(
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.key),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: TextField(
                            controller: passwordInput,
                            focusNode: passwordFocus,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            autocorrect: false,
                            // enableSuggestions: false,
                            onEditingComplete: (){
                              loginController(context);
                            },
                          )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30,),
            SizedBox(
              width: 280,
              child: Row(
                children: [
                  Expanded(child: Container()),
                  Material(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: (){
                        loginController(context);
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
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}