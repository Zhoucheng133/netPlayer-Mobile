// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItem extends StatefulWidget {

  final bool isSet;
  final String name;

  const MenuItem({super.key, required this.isSet, required this.name});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.name,
          style: GoogleFonts.notoSansSc(
            fontSize: 16,
            color: widget.isSet ? Colors.black : Colors.grey[500],
          ),
        ),
        SizedBox(height: 5,),
        AnimatedOpacity(
          opacity: widget.isSet ? 1 : 0,
          duration: Duration(milliseconds: 200),
          child: Container(
            width: 30,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(2)
            ),
          ),
        )
      ],
    );
  }
}

class IndexPinItem extends StatefulWidget {

  final IconData icon;
  final String label;
  final Color bgColor;
  final Color contentColor;

  const IndexPinItem({super.key, required this.icon, required this.label, required this.bgColor, required this.contentColor});

  @override
  State<IndexPinItem> createState() => _IndexPinItemState();
}

class _IndexPinItemState extends State<IndexPinItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.bgColor,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: Icon(
                widget.icon,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(80)
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: GoogleFonts.notoSansSc(
                    color: Colors.white,
                    fontSize: 15
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}