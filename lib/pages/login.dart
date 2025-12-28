import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  bool loading=false;


  @override
  void dispose() {
    urlFocus.dispose();
    usernameFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

   String normalizeUrl(String url) {
    if (url.endsWith('/')) {
      return url.substring(0, url.length - 1);
    }
    return url;
  }

  Future<void> loginController(BuildContext context) async {
    if(urlInput.text.isEmpty){
      d.showOkDialog(
        context: context,
        title: 'loginFailed'.tr,
        content: 'noURL'.tr,
        okText: 'ok'.tr
      );
    }else if(usernameInput.text.isEmpty){
      d.showOkDialog(
        context: context,
        title: 'loginFailed'.tr,
        content: 'noUsername'.tr,
        okText: 'ok'.tr
      );
    }else if(passwordInput.text.isEmpty){
      d.showOkDialog(
        context: context,
        title: 'loginFailed'.tr,
        content: 'noPassword'.tr,
        okText: 'ok'.tr
      );
    }else if(!urlInput.text.startsWith('http://') && !urlInput.text.startsWith('https://')){
      d.showOkDialog(
        context: context,
        title: 'loginFailed'.tr,
        content: 'urlInvalid'.tr,
        okText: 'ok'.tr
      );
    }else{
      setState(() {
        loading=true;
      });
      var salt=account.generateRandomString(6);
      var bytes = utf8.encode(passwordInput.text+salt);
      var token = md5.convert(bytes);
      var resp=await account.login(normalizeUrl(urlInput.text), usernameInput.text, token.toString(), salt);
      if(resp['ok']){
        u.username.value=usernameInput.text;
        u.salt.value=salt;
        u.url.value=normalizeUrl(urlInput.text);
        u.token.value=token.toString();
        u.password.value=passwordInput.text;
        SharedPreferences prefs=await SharedPreferences.getInstance();
        prefs.setString('url', normalizeUrl(urlInput.text));
        prefs.setString('username', usernameInput.text);
        prefs.setString('token', token.toString());
        prefs.setString('salt', salt);
        prefs.setString("password", passwordInput.text);
      }else{
        WidgetsBinding.instance.addPostFrameCallback((_) {
          d.showOkDialog(
            context: context,
            title: 'loginFailed'.tr,
            content: resp['data'],
            okText: 'ok'.tr
          );
        });
      }
      setState(() {
        loading=false;
      });
    }
  }

  SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(()=>
        AbsorbPointer(
          absorbing: loading,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "connectToYourMusicServer".tr,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 50),
                child: Text(
                  "inputYourMusicServerInfo".tr,
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
                        "serverURL".tr,
                        style: TextStyle(
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
                        "username".tr,
                        style: TextStyle(
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
                        "password".tr,
                        style: TextStyle(
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
                      color: loading ? Colors.blue.withAlpha(100) : Colors.blue,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 10,),
                              Text(
                                "login".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              !loading ? const Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white,
                                size: 30,
                              ) : const Padding(
                                padding: EdgeInsets.only(left: 10.0,),
                                child: SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
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
      ),
    );
  }
}