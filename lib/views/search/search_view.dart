import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/widgets/m_title.dart';
import '../../routes/pages.dart';
import '../../screens/common/mySliverControlBar.dart';
import '../../screens/common/mySliverControlList.dart';
import '../../util/mycss.dart';
import '../../widgets/common/m_song_table.dart';
import '../../widgets/m_bottom_placeholder.dart';
import '../../widgets/m_cover.dart';
import 'search_controller.dart';

class SearchViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchViewController>(() => SearchViewController());
  }
}

class SearchView extends GetView<SearchViewController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.search)),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Obx(
              () => CustomScrollView(
                slivers: [
                  if (controller.songs.isNotEmpty)
                    SliverToBoxAdapter(child: MTitle(title: S.current.song)),
                  if (controller.songs.isNotEmpty)
                    SliverToBoxAdapter(child: MSongTableHead()),
                  if (controller.songs.isNotEmpty)
                    SliverList.builder(
                      itemCount: controller.songs.length,
                      itemBuilder: (ctx, index) {
                        return _buildSongItem(controller.songs[index], index);
                      },
                    ),
                  if (controller.albums.isNotEmpty)
                    SliverToBoxAdapter(
                      child: MySliverControlBar(
                        title: S.current.album,
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
                  if (controller.artists.isNotEmpty)
                    SliverToBoxAdapter(
                      child: MySliverControlBar(
                        title: S.current.artist,
                        controller: controller.artistcontroller,
                      ),
                    ),
                  if (controller.artists.isNotEmpty)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 200,
                        child: Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: controller.artistcontroller,
                            itemCount: controller.artists.length,
                            itemBuilder: (ctx, index) {
                              var artistsTem = controller.artists[index];
                              return Container(
                                padding: index == 0
                                    ? leftrightPadding
                                    : EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.offNamed(
                                      Routes.ARTIST_DETAIL,
                                      arguments: {"id": artistsTem.id},
                                      preventDuplicates: false,
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: MCover(
                                              url: artistsTem.artistImageUrl)),
                                      SizedBox(height: 5),
                                      Container(
                                        constraints:
                                            BoxConstraints(maxWidth: 200 - 67),
                                        child: Text(
                                          artistsTem.name,
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
          )
        ],
      ),
    );
  }

  _buildHeader() {
    return TextField(
      controller: controller.searchController,
      onSubmitted: (value) {
        controller.search();
      },
    );
  }

  _buildSongItem(Songs song, int index) {
    return MSongTableRow(
      song: song,
      index: index,
      onTap: () {
        controller.audioPlayerService
            .palySongList(controller.songs, index: index);
      },
    );
  }
}
