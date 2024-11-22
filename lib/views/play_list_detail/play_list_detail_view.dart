import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_table_list.dart';
import 'package:musify/widgets/m_text.dart';
import '../../generated/l10n.dart';
import 'play_list_detail_controller.dart';

class PlayListDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayListDetailController());
  }
}

class PlayListDetailView extends GetView<PlayListDetailController> {
  final player = AudioPlayerService.player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Obx(() => Text(controller.albumsname.value))),
        body: SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHead()),
            SliverToBoxAdapter(child: _buildTableTitle()),
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
    return Container(
      padding: EdgeInsets.all(StyleSize.space),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => MCover(
              size: 180,
              url: controller.arturl.value,
            ),
          ),
          SizedBox(width: StyleSize.spaceLarge),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => MText(
                    text: S.current.song +
                        ": " +
                        controller.songsnum.value.toString(),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 5),
                Obx(
                  () => MText(
                    text: S.current.dration +
                        ": " +
                        formatDuration(controller.duration.value),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: 5),
                Obx(
                  () => MText(
                    text: S.current.playCount +
                        ": " +
                        controller.playCount.value.toString(),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTableTitle() {
    return MTableList(
      isHead: true,
      data: [
        MColumn(flex: 1, text: S.current.song),
        MColumn(
          text: (S.current.album),
          show: !isMobile,
        ),
        MColumn(text: (S.current.artist)),
        MColumn(text: (S.current.dration)),
        MColumn(text: (S.current.bitRange), show: !isMobile),
        MColumn(text: (S.current.playCount), show: !isMobile),
      ],
      divider: true,
    );
  }

  _buildTableItem(int index) {
    Songs _song = controller.songslist[index];
    return Dismissible(
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
        color: Colors.red,
        child: ListTile(
          trailing: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: _buildItem(_song, index),
    );
  }

  _buildItem(Songs _song, int index) {
    return ListTile(
      title: GestureDetector(
        onTap: () async {
          controller.audioPlayerService
              .palySongList(_song, index, controller.songslist);
        },
        child: MTableList(
          data: [
            MColumn(flex: 1, text: (_song.title)),
            MColumn(
              text: _song.album,
              width: 150,
              show: !isMobile,
            ),
            MColumn(text: (_song.artist)),
            MColumn(text: (formatDuration(_song.duration))),
            MColumn(
              text: (_song.suffix + "(" + _song.bitRate.toString() + ")"),
              show: !isMobile,
            ),
            MColumn(
              text: (_song.playCount.toString()),
              show: !isMobile,
            ),
          ],
        ),
      ),
    );
  }
}
