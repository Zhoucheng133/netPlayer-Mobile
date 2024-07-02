import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/variables.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool out=false;

  final Variables c = Get.put(Variables());
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 248, 249, 255),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                width: MediaQuery.of(context).size.width - 30,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                '歌单',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  leading: Icon(Icons.label),
                  title: Text('List Item $index'),
                );
              },
              childCount: 100,
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(height: 100,),
          )
        ],
      )
    );
  }
}