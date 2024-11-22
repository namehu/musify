import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';

import 'play_list_controller.dart';

class PlayListView extends GetView<PlayListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Badge.count(
                count: controller.playlistnum,
                offset: Offset(20, 0),
                child: Container(
                  child: Text(S.current.playlist),
                ),
              ),
            ),
            Container(
              child: IconButton(
                onPressed: controller.addPlayList,
                icon: Icon(
                  Icons.add_circle,
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHead(),
            _buildList(context),
          ],
        ),
      ),
    );
  }

  _buildList(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: controller.playlistnum,
            itemExtent: 50.0, //强制高度为50.0
            itemBuilder: (BuildContext context, int index) {
              Playlist _tem = controller.playlistsList[index];

              return Dismissible(
                // Key
                key: Key(_tem.id),
                confirmDismiss: (direction) {
                  bool _result = false;
                  if (direction == DismissDirection.endToStart && isMobile) {
                    // 从右向左  也就是删除
                    _result = true;
                  } else if (direction == DismissDirection.startToEnd) {
                    //从左向右
                    _result = false;
                  }
                  return Future<bool>.value(_result);
                },
                onDismissed: isMobile
                    ? (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          // controller.handleSwipeDelPlayList(_tem.id);
                        }
                      }
                    : null,
                background: Container(
                  color: Colors.red,
                  child: ListTile(
                    trailing: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                child: ListTile(
                  title: GestureDetector(
                    onTap: () async {
                      // activeID.value = _tem.id;
                      // indexValue.value = 12;
                    },
                    onSecondaryTapDown: (details) {
                      controller.handleSecondaryTapDel(
                        context,
                        details.globalPosition.dx,
                        details.globalPosition.dy,
                        _tem.id,
                      );
                    },
                    child: _buildRow(_tem),
                  ),
                ),
              );
            },
          )),
    );
  }

  // S.current.udpateDate
  _buildHead() {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 24, right: 24),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: ThemeService.color.borderColor, width: 0.5),
      )),
      child: Row(
        children: [
          Expanded(child: Text(S.current.name)),
          Container(
            width: 100,
            child: Text(S.current.song),
          ),
          Container(
            width: 100,
            child: Text(S.current.dration),
          ),
          if (!isMobile)
            Container(
              width: 100,
              child: Text(S.current.createuser),
            ),
          if (!isMobile)
            Container(
              width: 100,
              child: Text(S.current.udpateDate),
            ),
        ],
      ),
    );
  }

  _buildRow(Playlist data) {
    return Row(
      children: [
        Expanded(child: Text(data.name)),
        Container(
          width: 100,
          child: Text(data.songCount.toString()),
        ),
        Container(
          width: 100,
          child: Text(formatDuration(data.duration)),
        ),
        if (!isMobile)
          Container(
            width: 100,
            child: Text(data.owner),
          ),
        if (!isMobile)
          Container(
            width: 100,
            child: Text(timeISOtoString(data.changed)),
          ),
      ],
    );
  }
}
