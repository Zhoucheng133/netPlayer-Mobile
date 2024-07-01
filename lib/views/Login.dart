import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/Variables.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final Variables c = Get.put(Variables());

  TextEditingController urlInput=TextEditingController();
  TextEditingController usernameInput=TextEditingController();
  TextEditingController passwordInput=TextEditingController();

  FocusNode urlNode=FocusNode();
  FocusNode usernameNode=FocusNode();
  FocusNode passwordNode=FocusNode();
  

  bool tapLogin=false;

  void loginController(BuildContext context){
    // TODO 登录
  }

  @override
  void dispose() {
    super.dispose();
    urlNode.dispose();
    usernameNode.dispose();
    passwordNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 500,),
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
                              focusNode: urlNode,
                              controller: urlInput,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              autocorrect: false,
                              enableSuggestions: false,
                              onEditingComplete: (){
                                try {
                                  FocusScope.of(context).requestFocus(usernameNode);
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
                              focusNode: usernameNode,
                              controller: usernameInput,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              autocorrect: false,
                              enableSuggestions: false,
                              onEditingComplete: (){
                                try {
                                  FocusScope.of(context).requestFocus(passwordNode);
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
                              focusNode: passwordNode,
                              controller: passwordInput,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              autocorrect: false,
                              enableSuggestions: false,
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
                          color: tapLogin ? c.color2 : c.color4,
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
        ),
      ),
    );
  }
}