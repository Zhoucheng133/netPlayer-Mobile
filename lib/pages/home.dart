import 'package:flutter/material.dart';
import 'package:netplayer_mobile/components/play_view.dart';
import 'package:netplayer_mobile/operations/account.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Account account=Account();
  late OverlayEntry entry;

  void removeOverlay(){
    entry.remove();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      entry=OverlayEntry(
        builder: (BuildContext context) => const PlayView()
      );
      Overlay.of(context).insert(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: (){
          account.logout();
          removeOverlay();
        },
        child: const Text('注销')
      ),
    );
  }
}