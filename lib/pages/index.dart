import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/pages/all.dart';
import 'package:netplayer_mobile/pages/album_content.dart';
import 'package:netplayer_mobile/pages/albums.dart';
import 'package:netplayer_mobile/pages/artist_content.dart';
import 'package:netplayer_mobile/pages/artists.dart';
import 'package:netplayer_mobile/pages/components/index_content.dart';
import 'package:netplayer_mobile/pages/components/playing_bar.dart';
import 'package:netplayer_mobile/pages/download.dart';
import 'package:netplayer_mobile/pages/loved.dart';
import 'package:netplayer_mobile/pages/playlist.dart';
import 'package:netplayer_mobile/pages/search.dart';
import 'package:netplayer_mobile/pages/search_in.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Navigator(
            key: Get.nestedKey(1),
            initialRoute: '/index',
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case "/index":
                  return GetPageRoute(page: () => IndexContent());
                case "/all":
                  return GetPageRoute(page: () => All());
                case "/loved":
                  return GetPageRoute(page: () => Loved());
                case "/download":
                  return GetPageRoute(page: () => const Download());
                case "/artists":
                  return GetPageRoute(page: () => const Artists());
                case "/albums":
                  return GetPageRoute(page: () => const Albums());
                case "/search":
                  return GetPageRoute(page: () => const Search());
                case "/search-in": {
                  final args = settings.arguments as Map<String, dynamic>;
                  return GetPageRoute(page: () => SearchIn(
                    ls: args['ls'] as List,
                    from: args['from'] as String,
                    mode: args['mode'] as String,
                    listId: args['listId'] as String,
                  ));
                }
                case "/playlist": {
                  final args = settings.arguments as Map<String, dynamic>;
                  return GetPageRoute(page: () => Playlist(
                    id: args['id'] as String,
                    name: args['name'] as String,
                    songCount: args['songCount'] as int,
                  ));
                }
                case "/artist": {
                  final args = settings.arguments as Map<String, dynamic>;
                  return GetPageRoute(page: () => ArtistContent(
                    id: args['id'] as String,
                    artist: args['artist'] as String,
                    albumCount: args['albumCount'] as int? ?? 0,
                  ));
                }
                case "/album": {
                  final args = settings.arguments as Map<String, dynamic>;
                  return GetPageRoute(page: () => AlbumContent(
                    album: args['album'] as String,
                    id: args['id'] as String,
                    songCount: args['songCount'] as int? ?? 0,
                  ));
                }
                default:
              }
              return null;
            },
          )
        ),
        const PlayingBar()
      ],
    );
  }
}