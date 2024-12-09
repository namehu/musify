import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/common/m_song_table.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import '../../styles/size.dart';
import '../../widgets/sliver/sliver_header_delegate.dart';
import 'song_list_controller.dart';
import 'widgets/phone_bar.dart';

class SongListBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SongListController());
  }
}

class SongListView extends GetResponsiveView<SongListController> {
  SongListView({super.key});

  @override
  Widget builder() {
    return Scaffold(
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          SliverAppBar(
            pinned: true, // 滑动到顶端时会固定住
            expandedHeight: 200.0,
            leading: InkWell(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back_ios_outlined),
            ),
            title: Obx(() {
              return controller.showTitle.value
                  ? Text(S.current.allSong)
                  : Container();
            }),
            flexibleSpace: ValueListenableBuilder(
                valueListenable: controller.pagingController,
                builder: (c, ctr, cc) {
                  var list = ctr.itemList ?? [];
                  var song = list.firstOrNull;

                  return PhoneBar(
                    title: S.current.allSong,
                    cover: song?.coverUrl,
                  );
                }),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverHeaderDelegate(
              maxHeight: 48,
              minHeight: 48,
              child: _buildPhoneOperationRow(),
            ),
          ),
          PagedSliverList<int, Songs>(
            pagingController: controller.pagingController,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) =>
                  _buildSongList(item, index),
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
    );
  }

  // 构建 header
  Widget _buildPhoneOperationRow() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: StyleSize.space,
      ),
      decoration: BoxDecoration(
        color: ThemeService.color.secondBgColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => controller.playSong(),
            child: Row(
              children: [
                Icon(
                  Icons.play_circle,
                  size: 36,
                  color: ThemeService.color.primaryColor,
                ),
                SizedBox(width: StyleSize.spaceSmall),
                Text(S.current.playAll),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildSongList(Songs song, int index) {
    return Obx(() {
      var isActive =
          controller.audioPlayerService.currentSong.value.id == song.id;
      return MSongTableRow(
        song: song,
        index: index,
        showIndex: true,
        active: isActive,
        onTap: () {
          controller.playSong(index);
        },
      );
    });
  }
}
