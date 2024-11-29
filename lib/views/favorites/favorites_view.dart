import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/views/favorites/widgets/album_tab.dart';
import 'package:musify/views/favorites/widgets/artist_tab.dart';
import 'package:musify/views/favorites/widgets/song_tab.dart';
import 'favorites_controller.dart';

class FavoritesViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesController());
  }
}

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return FavoriteContent(controller: controller);
  }
}

class FavoriteContent extends StatefulWidget {
  final FavoritesController controller;
  const FavoriteContent({
    super.key,
    required this.controller,
  });

  @override
  State<FavoriteContent> createState() => _FavoriteContentState();
}

class _FavoriteContentState extends State<FavoriteContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isMobile,
        title: Row(
          children: [
            if (!isMobile) Text(S.current.favorite),
            Expanded(
              child: _tabHead(),
              flex: 3,
            ),
            Container(
              width: 48,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Obx(
            () => SongTab(
              songs: widget.controller.songs.value,
              songsFav: widget.controller.songsFav.value,
            ),
          ),
          Obx(
            () => AlbumTab(
              data: widget.controller.albums.value,
              favs: widget.controller.albumsFav.value,
            ),
          ),
          Obx(
            () => ArtistTab(
              data: widget.controller.artists.value,
              favs: widget.controller.artistsFav.value,
            ),
          ),
        ],
      ),
    );
  }

  _tabHead() {
    return Center(
      child: UnconstrainedBox(
        child: Container(
          height: 30,
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: 210),
          child: Obx(
            () => TabBar(
              padding: EdgeInsets.all(0),
              labelPadding: EdgeInsets.zero,
              dividerHeight: 0,
              controller: _tabController,
              unselectedLabelColor: Colors.white.withOpacity(0.8),
              tabs: [
                Tab(text: widget.controller.songFavText),
                Tab(text: widget.controller.albumsFavCountText),
                Tab(text: widget.controller.artistsFavCountText),
              ],
              labelStyle: nomalText,
            ),
          ),
        ),
      ),
    );
  }
}
