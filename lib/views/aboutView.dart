// ignore_for_file: file_names, prefer_const_constructors, camel_case_types, prefer_const_literals_to_create_immutables
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/para/para.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class aboutView extends StatefulWidget {
  const aboutView({super.key});

  @override
  State<aboutView> createState() => _aboutViewState();
}

class _aboutViewState extends State<aboutView> {

  final Controller c = Get.put(Controller());
  
  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version=packageInfo.version;
    });
  }
  
  String version="";

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  Future<void> openURL(String url) async {
    await launchUrl(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("关于"),
        scrolledUnderElevation:0.0,
        backgroundColor: Colors.white,
        foregroundColor: c.mainColor,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: c.mainColor
        ),
        leading: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icon.png",
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 10,),
                Text(
                  "netPlayer Mobile",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 8,),
                Text(
                  // c.version.value,
                  "v.$version",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    openURL("https://github.com/Zhoucheng133/netPlayer-Mobile");
                  },
                  child: Row(
                    children: [
                      Icon(Icons.code_rounded),
                      SizedBox(width: 5,),
                      Text(
                        "Github",
                        style: TextStyle(
                          fontSize: 15
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ]
      ),
    );
  }
}