import 'package:flutter/material.dart';
import 'package:netplayer_mobile/pages/components/search_box.dart';
import 'package:netplayer_mobile/pages/components/title_aria.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  TextEditingController textController=TextEditingController();
  FocusNode focus=FocusNode();
  ScrollController controller=ScrollController();
  bool showAppbarTitle=false;
  List ls=[];

  @override
  void initState() {
    super.initState();
    focus.requestFocus();
    controller.addListener((){
      if(controller.offset>60){
        setState(() {
          showAppbarTitle=true;
        });
      }else{
        setState(() {
          showAppbarTitle=false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        scrolledUnderElevation:0.0,
        toolbarHeight: 70,
        title: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: showAppbarTitle ? const Text('搜索', key: Key("1"),) : null,
          ),
        ),
        centerTitle: false,
      ),
      body: CustomScrollView(
        controller: controller,
        slivers: [
          const SliverToBoxAdapter(
            child: TitleAria(title: '搜索', subtitle: "")
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SearchBox(
              (context)=>SearchInput(
                textController: textController, focus: focus, search: (){},
              ),
            ),
          ),
          SliverList.builder(
            itemCount: 100,
            itemBuilder: (context, index){
              return Text(index.toString());
            }
          ),
        ],
      ),
    );
  }
}