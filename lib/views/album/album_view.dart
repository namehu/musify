import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/constant.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';
import 'package:musify/views/album/album_controller.dart';
import 'package:musify/widgets/common/m_song_table.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:musify/widgets/m_text.dart';
import 'package:musify/widgets/music/icon_play.dart';
import 'package:musify/widgets/sliver/sliver_header_delegate.dart';

class AlbumBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlbumController());
  }
}

class AlbumView extends GetView<AlbumController> {
  const AlbumView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverAppBar(
              pinned: true, // 滑动到顶端时会固定住
              expandedHeight: controller.headHeight,
              backgroundColor: controller.imageMainColor,
              leading: InkWell(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back_ios_outlined),
              ),
              title: Obx(() {
                return controller.showTitle.value
                    ? Text(controller.album.title)
                    : Container();
              }),
              flexibleSpace: FlexibleSpaceBar(
                background: _buildTopHead(),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildOperations(),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverHeaderDelegate(
                maxHeight: 48,
                minHeight: 48,
                child: MSongTableHead(),
              ),
            ),
            SliverList.builder(
              itemCount: controller.album.song.length,
              itemBuilder: (context, index) {
                var song = controller.album.song[index];
                return _buildSongList(song, index);
              },
            ),
            SliverToBoxAdapter(child: MBottomPlaceholder()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHead() {
    double fullAppBarHeight = statusBarHeight + appBarHeight;
    double coverMargin = isMobile ? StyleSize.spaceSmall : StyleSize.space * 2;
    double coverSize = controller.headHeight - fullAppBarHeight - coverMargin;

    return SizedBox(
      height: controller.headHeight,
      child: Stack(
        children: [
          SizedBox.expand(
            child: ClipRect(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Obx(
                  () => Container(
                    color: controller.imageMainColor,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: StyleSize.spaceLarge),
            color: controller.imageMainColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: fullAppBarHeight),
                Container(
                    margin: EdgeInsets.only(bottom: coverMargin),
                    child: LayoutBuilder(builder: (ctx, con) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(
                            () => MCover(
                              url: controller.album.coverUrl,
                              size: coverSize,
                            ),
                          ),
                          SizedBox(width: StyleSize.space),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMobile)
                                Obx(
                                  () => Text(
                                    S.current.album,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: controller.textColor,
                                    ),
                                  ),
                                ),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: con.maxWidth -
                                      coverSize -
                                      StyleSize.space,
                                ),
                                child: Obx(
                                  () => Text(
                                    controller.album.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: controller.textColor,
                                      fontSize: isMobile ? 32 : 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => Row(
                                  children: [
                                    if (controller.album.year != 0 && !isMobile)
                                      Icon(Icons.music_note_rounded),
                                    if (controller.album.year != 0 && !isMobile)
                                      Text(
                                        '${S.current.year}: ${controller.album.year}',
                                        style: TextStyle(
                                          color: controller.textColor,
                                        ),
                                      ),
                                    if (controller.album.year != 0 && !isMobile)
                                      _buildDot(),
                                    MText(
                                      text:
                                          "${S.current.song}: ${controller.album.songCount}",
                                      style: TextStyle(
                                        color: controller.textColor,
                                      ),
                                    ),
                                    _buildDot(),
                                    MText(
                                      text:
                                          "${S.current.duration}: ${formatDuration(controller.album.duration)}",
                                      style: TextStyle(
                                        color: controller.textColor,
                                      ),
                                    ),
                                    if (!isMobile) _buildDot(),
                                    if (!isMobile)
                                      MText(
                                        text:
                                            "${S.current.playCount}: ${controller.album.playCount}",
                                        style: TextStyle(
                                          color: controller.textColor,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                              Obx(
                                () => Text(
                                  controller.album.artist,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: controller.textColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    })),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildDot() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: StyleSize.spaceSmall),
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: controller.textColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  _buildOperations() {
    return Container(
      padding: allPadding,
      color: ThemeService.color.bgColor,
      child: Row(
        children: [
          IconPlay(
            onTap: () => controller.playSong(),
          ),
          SizedBox(width: StyleSize.space),
          Obx(
            () => MStarToogle(
              value: controller.album.starred,
              onChange: (val) async {
                controller.handleStarToggle(val);
              },
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
