import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class AlbumSkeleton extends StatefulWidget {
  const AlbumSkeleton({super.key});

  @override
  State<AlbumSkeleton> createState() => _AlbumSkeletonState();
}

class _AlbumSkeletonState extends State<AlbumSkeleton> {

  SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        color: Colors.transparent,
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 30,
              child: Center(
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: 20,
                    height: 20,
                  )
                ),
              ),
            ),
            const SizedBox(width: 10,),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      width: 200,
                    ),
                  ),
                  SizedBox(height: 6,),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 12,
                      width: 50,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10,),
            IconButton(
              onPressed: null,
              icon: Icon(
                Icons.more_vert_rounded,
                color: s.darkMode.value ? Colors.white : Colors.black,
                size: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}