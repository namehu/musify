import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/views/favorites/widgets/album_tab.dart';
import 'package:musify/views/favorites/widgets/artist_tab.dart';
import 'package:musify/views/favorites/widgets/song_tab.dart';

import '../../models/myModel.dart';
import '../../models/songs.dart';
import '../../util/httpclient.dart';
import 'favorites_controller.dart';

class FavoritesViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesController());
  }
}

class FavoritesView extends GetView<FavoritesController> {
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
  late TabController _tabController;
  List<Tab> myTabs = <Tab>[
    Tab(text: S.current.song + "(0)"),
    Tab(text: S.current.album + "(0)"),
    Tab(text: S.current.artist + "(0)")
  ];

  List<Songs> _songs = [];
  List<Albums> _albums = [];
  List<Artists> _artists = [];
  List<bool> _starsongs = [];
  List<bool> _staralbums = [];
  List<bool> _starartists = [];

  _getFavorite() async {
    final _favoriteList = await getStarred();
    if (_favoriteList != null) {
      var songs = _favoriteList["song"];
      var albums = _favoriteList["album"];
      var artists = _favoriteList["artist"];
      List<Songs> _songs1 = [];
      List<Albums> _albums1 = [];
      List<Artists> _artists1 = [];
      List<bool> _starsongs1 = [];
      List<bool> _staralbums1 = [];
      List<bool> _starartists1 = [];

      if (songs != null && songs.length > 0) {
        for (var _song in songs) {
          String _stream = await getServerInfo("stream");
          String _url = await getCoverArt(_song["id"]);
          _song["stream"] = _stream + '&id=' + _song["id"];
          _song["coverUrl"] = _url;
          if (_song["starred"] != null) {
            _starsongs1.add(true);
          } else {
            _starsongs1.add(false);
          }
          _songs1.add(Songs.fromJson(_song));
        }
      }
      if (albums != null && albums.length > 0) {
        for (var _album in albums) {
          String _url = await getCoverArt(_album["id"]);
          _album["coverUrl"] = _url;
          if (_album["starred"] != null) {
            _staralbums1.add(true);
          } else {
            _staralbums1.add(false);
          }
          _albums1.add(Albums.fromJson(_album));
        }
      }
      if (artists != null && artists.length > 0) {
        for (var _artist in artists) {
          String _url = await getCoverArt(_artist["id"]);
          _artist["artistImageUrl"] = _url;
          if (_artist["starred"] != null) {
            _starartists1.add(true);
          } else {
            _starartists1.add(false);
          }
          _artists1.add(Artists.fromJson(_artist));
        }
      }
      if (mounted) {
        setState(() {
          _songs = _songs1;
          _albums = _albums1;
          _artists = _artists1;
          _starsongs = _starsongs1;
          _staralbums = _staralbums1;
          _starartists = _starartists1;
          myTabs = <Tab>[
            Tab(text: S.current.song + "(" + _songs.length.toString() + ")"),
            Tab(text: S.current.album + "(" + _albums.length.toString() + ")"),
            Tab(text: S.current.artist + "(" + _artists.length.toString() + ")")
          ];
        });
      }
    }
  }

  @override
  initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isMobile,
        title: Row(
          children: [
            if (!isMobile)
              Container(
                child: Text(S.current.favorite),
              ),
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
                Tab(
                  text: widget.controller.songFavText,
                ),
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
