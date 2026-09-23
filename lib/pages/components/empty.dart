import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Empty extends StatefulWidget {
  const Empty({super.key});

  @override
  State<Empty> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        spacing: 10,
        children: [
          FaIcon(FontAwesomeIcons.boxOpen),
          Text('empty'.tr),
        ],
      ),
    );
  }
}

class NoPlaylist extends StatefulWidget {
  const NoPlaylist({super.key});

  @override
  State<NoPlaylist> createState() => _NoPlaylistState();
}

class _NoPlaylistState extends State<NoPlaylist> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      spacing: 10,
      children: [
        FaIcon(FontAwesomeIcons.boxOpen), 
        Text('noplaylist'.tr),
      ],
    );
  }
}