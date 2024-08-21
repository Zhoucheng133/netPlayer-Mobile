import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/operations/account.dart';
import 'package:netplayer_mobile/operations/data_get.dart';
import 'package:netplayer_mobile/pages/components/index_body.dart';
import 'package:netplayer_mobile/variables/len_var.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {

  Account account=Account();
  late OverlayEntry entry;
  LenVar l=Get.put(LenVar());
  int pageIndex=0;
  DataGet dataGet=DataGet();

  void removeOverlay(){
    entry.remove();
  }

  @override
  void initState() {
    super.initState();
    dataGet.getPlayLists();
  }

  void logout(){
    account.logout();
    removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        leading: const Row(
          children: [
            SizedBox(width: 30,),
            Icon(
              Icons.search_rounded
            ),
          ],
        ),
        actions: const [
          Icon(
            Icons.more_vert_rounded
          ),
          SizedBox(width: 30,)
        ],
      ),
      body: Obx(()=>
        Padding(
          padding: EdgeInsets.only(bottom: l.bottomLen.value),
          child: const IndexBody()
        ),
      )
    );
  }
}