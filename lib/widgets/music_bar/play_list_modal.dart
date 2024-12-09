import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';

import '../sliver/sliver_header_delegate.dart';

class PlayListModal extends GetResponsiveView {
  final audioPlayerService = Get.find<AudioPlayerService>();

  PlayListModal({super.key});

  handleItemClick(Songs song, int index) {
    audioPlayerService.player.jump(index);
  }

  @override
  Widget? desktop() {
    return Container(
      height: double.infinity,
      // height: 500,
      width: 350,
      padding: EdgeInsets.all(StyleSize.space),
      child: Container(
        padding: EdgeInsets.all(StyleSize.space),
        decoration: BoxDecoration(
            color: ThemeService.color.dialogBackgroundColor,
            borderRadius: BorderRadius.circular(StyleSize.smallBorderRadius),
            boxShadow: [
              BoxShadow(
                color: ThemeService.color.borderColor,
                blurRadius: 2,
              )
            ]),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverHeaderDelegate(
                maxHeight: 36,
                minHeight: 36,
                child: Container(
                  color: ThemeService.color.dialogBackgroundColor,
                  child: Column(
                    children: [
                      _buildHead(),
                      Divider(
                        color: ThemeService.color.dividerColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() {
              return SliverList.separated(
                itemCount: audioPlayerService.playSongs.length,
                separatorBuilder: (c, i) => Divider(
                  height: 1,
                  color: ThemeService.color.dividerColor,
                ),
                itemBuilder: _itemBuilder,
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget phone() {
    return Container(
      constraints: BoxConstraints(maxHeight: 500),
      decoration: BoxDecoration(
        color: ThemeService.color.dialogBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(StyleSize.borderRadius),
          topRight: Radius.circular(StyleSize.borderRadius),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(StyleSize.space),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: ThemeService.color.dividerColor,
                ),
              ),
            ),
            child: _buildHead(),
          ),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  _buildHead() {
    return Row(
      children: [
        SizedBox(width: 100),
        Expanded(
          child: Obx(
            () => Text(
              '${S.current.playlist}(${audioPlayerService.playSongs.length})',
              textAlign: TextAlign.center,
              style: TextStyle(color: ThemeService.color.textColor),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: Obx(() {
            var playMode = audioPlayerService.playMode.value;

            late String label;
            late IconData iconData;

            switch (playMode) {
              case PlayModeEnum.loop:
                label = S.current.repeatall;
                iconData = Icons.loop;
                break;
              case PlayModeEnum.single:
                label = S.current.repeatone;
                iconData = Icons.repeat_one;
                break;
              case PlayModeEnum.shuffle:
                label = S.current.shuffle;
                iconData = Icons.shuffle;
            }

            return GestureDetector(
              onTap: () => audioPlayerService.tooglePlayMode(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    iconData,
                    size: 12,
                    color: ThemeService.color.textSecondColor,
                  ),
                  SizedBox(width: 5),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeService.color.textSecondColor,
                    ),
                  )
                ],
              ),
            );
          }),
        )
      ],
    );
  }

  _buildList() {
    return MediaQuery.removePadding(
      context: Get.context!,
      removeTop: true,
      child: Obx(
        () {
          return ListView.separated(
            itemCount: audioPlayerService.playSongs.length,
            separatorBuilder: (c, i) => Divider(
              height: 1,
              color: ThemeService.color.dividerColor,
            ),
            itemBuilder: _itemBuilder,
          );
        },
      ),
    );
  }

  Widget? _itemBuilder(BuildContext context, int index) {
    return Obx(() {
      var currentSong = audioPlayerService.currentSong.value;

      var item = audioPlayerService.playSongs[index];
      var isActive = item.id == currentSong.id;
      return ListTile(
        onTap: () {
          handleItemClick(item, index);
        },
        leading: Text(
          (index + 1).toString().padLeft(2, '0'),
          style: TextStyle(
            fontSize: isActive ? 16 : 14,
            color: isActive
                ? ThemeService.color.primaryColor
                : ThemeService.color.textSecondColor,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            color: isActive
                ? ThemeService.color.primaryColor
                : ThemeService.color.textColor,
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            audioPlayerService.removeFromPlayList(index);
          },
          child: Icon(
            Icons.close,
            size: 18,
            color: ThemeService.color.iconColor,
          ),
        ),
      );
    });
  }
}
