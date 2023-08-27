// ignore_for_file: prefer_const_constructors, camel_case_types, file_names

import 'package:flutter/material.dart';

class artistsView extends StatefulWidget {
  const artistsView({super.key});

  @override
  State<artistsView> createState() => _artistsViewState();
}

class _artistsViewState extends State<artistsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("艺人"),
    );
  }
}