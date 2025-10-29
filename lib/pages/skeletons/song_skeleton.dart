import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:netplayer_mobile/variables/settings_var.dart';
import 'package:skeletons_forked/skeletons_forked.dart';

class SongSkeleton extends StatefulWidget {

  final bool showLoved;

  const SongSkeleton({super.key, this.showLoved = false});

  @override
  State<SongSkeleton> createState() => _SongSkeletonState();
}

class _SongSkeletonState extends State<SongSkeleton> {

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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonLine(
                    style: SkeletonLineStyle(
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 6,),
                  Row(
                    children: [
                      widget.showLoved ? const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                          size: 15,
                        ),
                      ) : Container(),
                      const Expanded(
                        child: SkeletonLine(
                          style: SkeletonLineStyle(
                            height: 12,
                            width: 50,
                          ),
                        ),
                      ),
                    ],
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