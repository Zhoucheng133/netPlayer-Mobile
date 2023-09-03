// ignore_for_file: prefer_const_constructors, camel_case_types, file_names

import 'package:flutter/material.dart';

class searchView extends StatefulWidget {
  const searchView({super.key});

  @override
  State<searchView> createState() => _searchViewState();
}

class _searchViewState extends State<searchView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("搜索"),
    );
  }
}