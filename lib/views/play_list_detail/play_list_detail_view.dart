import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/util/util.dart';
import 'package:musify/widgets/common/m_list_head.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_text.dart';
import '../../generated/l10n.dart';
import '../../widgets/common/m_media_bar.dart';
import '../../widgets/common/m_song_table.dart';
import 'play_list_detail_controller.dart';

class PlayListDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayListDetailController());
  }
}

class PlayListDetailView extends GetResponsiveView<PlayListDetailController> {
  PlayListDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: MMediaBar(
          title: Text(controller.name.value),
          count: controller.songsNum.value,
          onPlayClick: () {
            controller.audioPlayerService
                .palySongList(controller.songslist, index: 0);
          },
        ),
        body: SafeArea(
            child: Column(
          children: [
            _buildHead(),
            MSongTableHead(),
            Expanded(
              flex: 1,
              child: CustomScrollView(
                slivers: [
                  Obx(
                    () => controller.songslist.isEmpty
                        ? SliverToBoxAdapter(
                            child: Text(''),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildItem(index),
                              childCount: controller.songslist.length,
                            ),
                          ),
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  _buildHead() {
    return Obx(
      () => MListHead(
        cover: MCover(url: controller.coverUrl.value),
        title: controller.name.value,
        subWidgets: [
          MText(
            text:
                "${S.current.duration}: ${formatDuration(controller.duration.value)}",
            maxLines: 1,
          ),
          MText(
            text: "${S.current.playCount}: ${controller.playCount.value}",
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  _buildItem(int index) {
    Songs song = controller.songslist[index];
    return MSongTableRow(
      song: song,
      index: index,
      onTap: () {
        controller.audioPlayerService
            .palySongList(controller.songslist, index: index);
      },
    );
  }
}
