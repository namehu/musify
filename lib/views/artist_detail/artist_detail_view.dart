import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';
import 'package:musify/widgets/common/m_song_table.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_text.dart';
import 'package:musify/widgets/m_title.dart';
import '../../constant.dart';
import '../../screens/common/mySliverControlBar.dart';
import '../../screens/common/mySliverControlList.dart';
import 'artist_detail_controller.dart';

class ArtistDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtistDetailController>(
      () => ArtistDetailController(),
      fenix: true,
    );
  }
}

class ArtistDetailView extends GetView<ArtistDetailController> {
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();

  ArtistDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeService.color.secondBgColor,
      body: Obx(
        () => CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            SliverAppBar(
              pinned: true, // 滑动到顶端时会固定住
              expandedHeight: controller.headHeight,
              backgroundColor: controller.imageMainColor,
              foregroundColor: controller.imageMainColor,
              leading: InkWell(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: ThemeService.color.textColor,
                ),
              ),
              title: Obx(() {
                return controller.showTitle.value
                    ? Text(
                        controller.artilstname.value,
                        style: TextStyle(color: ThemeService.color.textColor),
                      )
                    : Container();
              }),
              flexibleSpace: FlexibleSpaceBar(
                background: _buildTopHead(),
              ),
            ),
            // SliverToBoxAdapter(child: _buildTopWidget()),
            SliverToBoxAdapter(child: _buildBiography()),

            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: StyleSize.space,
                  vertical: StyleSize.spaceSmall,
                ),
                child: MTitle(title: S.current.song),
              ),
            ),
            if (controller.topSongs.isNotEmpty)
              SliverToBoxAdapter(
                child: MSongTableHead(),
              ),
            if (controller.topSongs.isNotEmpty)
              SliverList.builder(
                itemCount: controller.topSongs.length,
                itemBuilder: (ctx, index) {
                  return _buildSongList(index);
                },
              ),
            if (controller.albums.isNotEmpty)
              SliverToBoxAdapter(
                child: MySliverControlBar(
                  title: "${S.current.album}(${controller.albums.length})",
                  controller: controller.albumscontroller,
                ),
              ),
            if (controller.albums.isNotEmpty)
              SliverToBoxAdapter(
                child: MySliverControlList(
                  controller: controller.albumscontroller,
                  albums: controller.albums,
                ),
              ),
            if (controller.similarArtist.isNotEmpty)
              SliverToBoxAdapter(
                child: MySliverControlBar(
                  title: S.current.artist,
                  controller: controller.similarArtistcontroller,
                ),
              ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: Obx(
                  () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: controller.similarArtistcontroller,
                    itemCount: controller.similarArtist.length,
                    itemBuilder: (ctx, index) {
                      var artist = controller.similarArtist[index];
                      return Container(
                        padding: index == 0
                            ? leftrightPadding
                            : EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: () {
                            Get.offNamed(
                              Routes.ARTIST_DETAIL,
                              arguments: {"id": artist['id']},
                              preventDuplicates: false,
                            );
                          },
                          child: Column(
                            children: [
                              Expanded(child: MCover(url: artist["coverUrl"])),
                              SizedBox(height: 5),
                              Container(
                                constraints: BoxConstraints(maxWidth: 200 - 67),
                                child: Text(
                                  artist["name"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: MBottomPlaceholder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHead() {
    /// TODO: 优化.这里与album_view中代码重复度很高
    double fullAppBarHeight = statusBarHeight + appBarHeight;
    double coverMargin = isMobile ? StyleSize.spaceSmall : StyleSize.space * 2;
    double coverSize = controller.headHeight - fullAppBarHeight - coverMargin;

    return SizedBox(
      height: controller.headHeight,
      child: Stack(
        children: [
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
                              url: controller.arturl.value,
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
                                    S.current.artist,
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
                                    controller.artilstname.value,
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
                                    MText(
                                      text:
                                          "${S.current.song}: ${controller.albumsnum.value}",
                                      style: TextStyle(
                                        color: controller.textColor,
                                      ),
                                    ),
                                    _buildDot(),
                                    MText(
                                      text:
                                          "${S.current.duration}: ${formatDuration(controller.duration.value)}",
                                      style: TextStyle(
                                        color: controller.textColor,
                                      ),
                                    ),
                                    if (!isMobile) _buildDot(),
                                    if (!isMobile)
                                      MText(
                                        text:
                                            "${S.current.playCount}: ${controller.playCount.value}",
                                        style: TextStyle(
                                          color: controller.textColor,
                                        ),
                                      )
                                  ],
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

  Widget _buildBiography() {
    return Obx(
      () => controller.biography.value.isNotEmpty
          ? Container(
              padding: EdgeInsets.all(StyleSize.space),
              child: Text(
                controller.biography.value,
                overflow: TextOverflow.ellipsis,
                maxLines: 100,
              ),
            )
          : Container(),
    );
  }

  _buildSongList(int index) {
    var song = controller.topSongs[index];

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
