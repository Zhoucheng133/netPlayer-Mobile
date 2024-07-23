import 'package:flutter/material.dart';

class PlayView extends StatefulWidget {
  const PlayView({super.key});

  @override
  State<PlayView> createState() => _PlayViewState();
}

class _PlayViewState extends State<PlayView> {

  bool onInit=true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        onInit=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      // curve: Curves.easeInOut,
      // bottom: 0,
      bottom: onInit ? -MediaQuery.of(context).size.height : -MediaQuery.of(context).size.height+MediaQuery.of(context).padding.bottom+90,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.blue[800],
          borderRadius: BorderRadius.circular(20)
        ),
      )
    );
  }
}