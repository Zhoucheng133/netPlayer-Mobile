import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/components/title_area.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {

  String version="";

  Future<void> initVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version=packageInfo.version;
    });
  }

  @override
  void initState() {
    super.initState();
    initVersion();
  }

  SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        backgroundColor: s.darkMode.value ? s.bgColor2 : Colors.white,
        appBar: AppBar(
          backgroundColor: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
          scrolledUnderElevation:0.0,
          toolbarHeight: 70,
        ),
        body: Column(
          children: [
            TitleArea(title: 'about'.tr, subtitle: ' '),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/icon.png")
                      )
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    'netPlayer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    "v$version",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      final url=Uri.parse('https://github.com/Zhoucheng133/netPlayer-Mobile');
                      launchUrl(url);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.github,
                          size: 15,
                        ),
                        const SizedBox(width: 5,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            'projectURL'.tr,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                  GestureDetector(
                    onTap: ()=>showLicensePage(
                      applicationName: 'netPlayer Mobile',
                      applicationVersion: version,
                      context: context,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.certificate,
                          size: 15,
                        ),
                        const SizedBox(width: 5,),
                        Text('license'.tr)
                      ],
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 150,)
          ],
        ),
      ),
    );
  }
}