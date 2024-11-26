import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';
import 'package:musify/widgets/common/m_list_head.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_table_list.dart';
import 'package:musify/widgets/m_text.dart';
import '../../generated/l10n.dart';
import '../../widgets/common/m_song_table.dart';
import 'play_list_detail_controller.dart';

class PlayListDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayListDetailController());
  }
}

class PlayListDetailView extends GetResponsiveView<PlayListDetailController> {
  final player = AudioPlayerService.player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Obx(() => Text(controller.albumsname.value))),
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHead()),
            SliverToBoxAdapter(child: MSongTableHead()),
            Obx(
              () => controller.songslist.isEmpty
                  ? SliverToBoxAdapter(
                      child: Text(''),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildTableItem(index),
                        childCount: controller.songslist.length,
                      ),
                    ),
            ),
          ],
        )));
  }

  _buildHead() {
    return Obx(
      () => MListHead(
        cover: MCover(url: controller.arturl.value),
        title: controller.albumsname.value,
        subWidgets: [
          MText(
            text: S.current.song + ": " + controller.songsnum.value.toString(),
            maxLines: 1,
          ),
          MText(
            text: S.current.dration +
                ": " +
                formatDuration(controller.duration.value),
            maxLines: 1,
          ),
          MText(
            text: S.current.playCount +
                ": " +
                controller.playCount.value.toString(),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  _buildTableItem(int index) {
    Songs _song = controller.songslist[index];
    return screen == ScreenType.Phone
        ? Dismissible(
            key: Key(_song.id),
            confirmDismiss: (direction) {
              bool _result = false;
              if (direction == DismissDirection.endToStart) {
                // 从右向左  也就是删除
                _result = true;
              } else if (direction == DismissDirection.startToEnd) {
                //从左向右
                _result = false;
              }
              return Future<bool>.value(_result);
            },
            onDismissed: (direction) async {
              if (direction == DismissDirection.endToStart) {
                // await delSongfromPlaylist(activeID.value, index.toString());

                // _getSongs(activeID.value);
                // MyToast.show(
                //     context: context,
                //     message: S.current.delete + S.current.success);
              } else if (direction == DismissDirection.startToEnd) {
                //从左向右
              }
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 24),
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: _buildItem(_song, index),
          )
        : _buildItem(_song, index);
  }

  _buildItem(Songs _song, int index) {
    return MSongTableRow(
      song: _song,
      index: index,
      onTap: () {
        controller.audioPlayerService
            .palySongList(_song, index, controller.songslist);
      },
    );
  }
}
