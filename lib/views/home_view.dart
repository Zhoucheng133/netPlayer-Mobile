import 'package:flutter/material.dart';
import 'package:netplayer_mobile/funcs/operations_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: (){
            Operations().logout();
          }, 
          child: Text('注销')
        ),
      ),
    );
  }
}