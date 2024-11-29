import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';
import 'package:musify/widgets/common/m_list_head.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_table_list.dart';
import 'package:musify/widgets/m_text.dart';
import 'package:musify/widgets/m_title.dart';
import 'package:musify/widgets/m_toast.dart';
import '../../screens/common/mySliverControlBar.dart';
import '../../screens/common/mySliverControlList.dart';
import '../../util/httpClient.dart';
import '../../widgets/m_star_toogle.dart';
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
      appBar: AppBar(title: Text(S.current.artist)),
      body: SafeArea(
        child: Obx(
          () => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildTopWidget()),
              SliverToBoxAdapter(child: _buildBiography()),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: StyleSize.space),
                  child: MTitle(title: S.current.song),
                ),
              ),
              if (controller.topSongs.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buidTopSongHead(),
                ),
              if (controller.topSongs.isNotEmpty)
                SliverList.builder(
                  itemCount: controller.topSongs.length,
                  itemBuilder: (ctx, index) {
                    return _buidTopSong(index);
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
                                Expanded(
                                    child: MCover(url: artist["coverUrl"])),
                                SizedBox(height: 5),
                                Container(
                                  constraints:
                                      BoxConstraints(maxWidth: 200 - 67),
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
      ),
    );
  }

  Widget _buildTopWidget() {
    return Obx(
      () => MListHead(
        cover: MCover(
          url: controller.arturl.value,
          shape: MCoverShapeEnum.squareRound,
        ),
        title: controller.artilstname.value,
        subWidgets: [
          Row(
            children: [
              Text(
                "${S.current.album}: ${controller.albumsnum.value}",
              ),
              SizedBox(width: 15),
              Text(
                "${S.current.song}: ${controller.songCount.value}",
              )
            ],
          ),
          MText(
            text:
                "${S.current.duration}: ${formatDuration(controller.duration.value)}",
          ),
          MText(
            text: "${S.current.playCount}: ${controller.playCount.value}",
          ),
        ],
      ),
    );
  }

  Widget _buildBiography() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(StyleSize.space),
        child: Text(
          controller.biography.value,
          overflow: TextOverflow.ellipsis,
          maxLines: 100,
        ),
      ),
    );
  }

  Widget _buidTopSongHead() {
    return MTableList(
      isHead: true,
      data: [
        MColumn(flex: 1, text: S.current.song),
        MColumn(text: S.current.album),
        MColumn(text: S.current.duration),
        MColumn(text: S.current.bitRange, show: !isMobile),
        MColumn(text: S.current.playCount, show: !isMobile),
        MColumn(text: S.current.favorite, width: 50),
      ],
    );
  }

  Widget _buidTopSong(int index) {
    var item = controller.topSongs[index];
    return InkWell(
      onTap: () {
        audioPlayerService.palySongList(
          controller.topSongs.value,
          index: index,
        );
      },
      child: MTableList(
        data: [
          MColumn(flex: 1, text: item.title),
          MColumn(text: item.album),
          MColumn(text: formatDuration(item.duration)),
          MColumn(text: item.bitRate.toString(), show: !isMobile),
          MColumn(text: item.playCount.toString(), show: !isMobile),
          MColumn(
            text: S.current.favorite,
            width: 50,
            child: Obx(
              () => MStarToogle(
                value: controller.topSongsFav[index],
                onChange: (value) async {
                  Favorite favorite = Favorite(id: item.id, type: 'song');
                  if (value) {
                    await addStarred(favorite);
                    MToast.show(S.current.add + S.current.favorite);
                  } else {
                    await delStarred(favorite);
                    MToast.show(S.current.cancel + S.current.favorite);
                  }

                  controller.topSongsFav[index] = value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
