// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:netplayer_mobile/operations/account.dart';

class Home extends StatefulWidget {

  final VoidCallback logout;

  const Home({super.key, required this.logout});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Account account=Account();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: TextButton(
          onPressed: (){
            widget.logout();
          },
          child: const Text('注销'),
        ),
      ),
    );
  }
}