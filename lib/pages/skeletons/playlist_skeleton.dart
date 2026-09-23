import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class PlaylistSkeleton extends StatefulWidget {
  const PlaylistSkeleton({super.key});

  @override
  State<PlaylistSkeleton> createState() => _PlaylistSkeletonState();
}

class _PlaylistSkeletonState extends State<PlaylistSkeleton> {

  SettingsVar s=Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Container(
        color: s.darkMode.value ? s.bgColor2 : Colors.white,
        height: 60,
        padding: const EdgeInsets.only(left: 20, right: 10),
        child: Row(
          children: [
            if(s.showPlaylistCover.value) Padding(
              padding: const EdgeInsets.only(right: 5),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(7),
                clipBehavior: Clip.antiAlias,
                child: SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    width: 50,
                    height: 50,
                  )
                ),
              ),
            ),
            const SizedBox(width: 5,),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SkeletonLine(
                      style: SkeletonLineStyle(
                        width: 200,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    SkeletonLine(
                      style: SkeletonLineStyle(
                        height: 12,
                        width: 50,
                      ),
                    ),
                  ],
                ),
              )
            ),
            IconButton(
              onPressed: (){},
              icon: const Icon(
                Icons.more_vert_rounded,
                size: 20,
              )
            )
          ],
        ),
      ),
    );
  }
}