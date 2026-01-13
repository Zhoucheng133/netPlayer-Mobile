import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class ArtistSkeleton extends StatefulWidget {
  const ArtistSkeleton({super.key});

  @override
  State<ArtistSkeleton> createState() => _ArtistSkeletonState();
}

class _ArtistSkeletonState extends State<ArtistSkeleton> {

  SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: s.darkMode.value ? s.bgColor2 : Colors.white,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
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
            SizedBox(width: 10,),
            Expanded(
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
          ],
        ),
      ),
    );
  }
}