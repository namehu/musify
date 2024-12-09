import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';
import 'package:musify/widgets/m_table_list.dart';

import 'play_list_controller.dart';

class PlayListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayListController());
  }
}

class PlayListView extends GetResponsiveView<PlayListController> {
  PlayListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isMobile,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Badge.count(
                count: controller.playlistnum,
                offset: Offset(20, 0),
                child: Text(S.current.playlist),
              ),
            ),
            // Container(
            //   child: IconButton(
            //     onPressed: controller.addPlayList,
            //     icon: Icon(
            //       Icons.add_circle,
            //     ),
            //   ),
            // )
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
              Playlist playListtem = controller.playlistsList[index];
              return _buidListItem(context, playListtem);
            },
          )),
    );
  }

  _buidListItem(BuildContext context, Playlist playListTem) {
    return InkWell(
      onTap: () async {
        Get.toNamed(Routes.PLAY_LIST_DETAIL, arguments: {'id': playListTem.id});
      },
      onSecondaryTapDown: (details) {
        controller.handleSecondaryTapDel(
          context,
          details.globalPosition.dx,
          details.globalPosition.dy,
          playListTem.id,
        );
      },
      child: _buildRow(playListTem),
    );
  }

  _buildHead() {
    return MTableList(
      isHead: true,
      data: [
        MColumn(flex: 1, text: S.current.name),
        MColumn(text: (S.current.song)),
        MColumn(text: (S.current.duration)),
        MColumn(text: (S.current.createuser), show: !isMobile),
        MColumn(text: (S.current.udpateDate), show: !isMobile),
      ],
      divider: true,
    );
  }

  _buildRow(Playlist data) {
    return MTableList(
      data: [
        MColumn(flex: 1, text: data.name),
        MColumn(text: (data.songCount.toString())),
        MColumn(text: (formatDuration(data.duration))),
        MColumn(text: (data.owner), show: !isMobile),
        MColumn(text: (timeISOtoString(data.changed)), show: !isMobile),
      ],
    );
  }
}
