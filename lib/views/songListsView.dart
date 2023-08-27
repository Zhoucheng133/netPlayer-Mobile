// ignore_for_file: prefer_const_constructors, camel_case_types, file_names

import 'package:flutter/material.dart';

class songListsView extends StatefulWidget {
  const songListsView({super.key});

  @override
  State<songListsView> createState() => _songListsViewState();
}

class _songListsViewState extends State<songListsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("歌单"),
    );
  }
}