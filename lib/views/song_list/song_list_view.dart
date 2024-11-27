import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/widgets/common/m_media_bar.dart';
import 'package:musify/widgets/common/m_song_table.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import '../../styles/size.dart';
import 'song_list_controller.dart';

class SongListBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SongListController());
  }
}

class SongListView extends GetView<SongListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MMediaBar(
        title: Text(S.current.allSong),
        onPlayClick: () {
          var list = controller.pagingController.itemList ?? [];
          if (list.length > 500) {
            list = list.sublist(0, 500);
          }
          Get.find<AudioPlayerService>().palySongList(list);
        },
      ),
      body: Column(
        children: [
          Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: StyleSize.space),
            child: Text('111'),
          ),
          MSongTableHead(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: StyleSize.space),
                ),
                PagedSliverList<int, Songs>(
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, item, index) => _buildItem(index),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(top: StyleSize.space),
                    child: MBottomPlaceholder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildItem(int index) {
    var _songs = controller.pagingController.itemList!;
    return MSongTableRow(
      song: _songs[index],
      index: index,
      onTap: () {
        Get.find<AudioPlayerService>().palySongList(_songs, index: index);
      },
    );
  }
}
