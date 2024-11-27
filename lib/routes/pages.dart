import 'package:get/get.dart';
import 'package:musify/routes/middlewares.dart';
import 'package:musify/views/album/album_view.dart';
import 'package:musify/views/album_list/album_list_view.dart';
import 'package:musify/views/artists/artists_view.dart';
import 'package:musify/views/changeServer/change_server_view.dart';
import 'package:musify/views/favorites/favorites_view.dart';
import 'package:musify/views/genre/genre_view.dart';
import 'package:musify/views/login/login_view.dart';
import 'package:musify/views/play/play_view.dart';
import 'package:musify/views/search/search_view.dart';
import 'package:musify/views/setting/setting_view.dart';
import 'package:musify/views/song_list/song_list_view.dart';
import '../views/artist_detail/artist_detail_view.dart';
import '../views/home/home_view.dart';
import 'package:musify/views/play_list/play_list_view.dart';
import '../views/play_list_detail/play_list_detail_view.dart';

part 'routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeViewBinding(),
    ),
    _loginPage,
    _changeServer,
    _setting,
    _albumList,
    _album,
    _play,
    _playList,
    _playListDetail,
    _favorite,
    GetPage(
      name: Routes.ARTISTS,
      page: () => ArtistsView(),
      binding: ArtistsViewBinding(),
    ),
    GetPage(
      name: Routes.ARTIST_DETAIL,
      page: () => ArtistDetailView(),
      binding: ArtistDetailBinding(),
    ),
    GetPage(
      name: Routes.GENRE,
      page: () => GenreView(),
      binding: GenreBinding(),
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => SearchView(),
      binding: SearchViewBinding(),
    ),
    GetPage(
      name: Routes.SONG_LIST,
      page: () => SongListView(),
      binding: SongListBinding(),
    ),
  ];

  static final _loginPage = GetPage(
    name: Routes.LOGIN,
    page: () => LoginView(),
    binding: LoginViewBinding(),
    middlewares: [MusicBarMiddleware(), PCloginMiddleware()],
  );

  static final _changeServer = GetPage(
    name: Routes.CHANGE_SERVER,
    page: () => ChangeServerView(),
    binding: ChangeServerBinding(),
    middlewares: [MusicBarMiddleware()],
  );

  static final _setting = GetPage(
    name: Routes.SETTING,
    page: () => SettingView(),
    binding: SettingBinding(),
    middlewares: [MusicBarMiddleware()],
  );

  static final _albumList = GetPage(
    name: Routes.ALBUM_LIST,
    page: () => AlbumListView(),
    binding: AlbumListBinding(),
    middlewares: [MusicBarMiddleware()],
  );

  static final _album = GetPage(
    name: Routes.ALBUM,
    page: () => AlbumView(),
    binding: AlbumBinding(),
    middlewares: [MusicBarMiddleware()],
  );

  static final _play = GetPage(
    name: Routes.PLAY,
    page: () => PlayView(),
    binding: PlayBinding(),
    middlewares: [MusicBarMiddleware()],
  );

  static final _playList = GetPage(
    name: Routes.PLAY_LIST,
    page: () => PlayListView(),
    binding: PlayListBinding(),
    middlewares: [MusicBarMiddleware()],
  );

  static final _playListDetail = GetPage(
    name: Routes.PLAY_LIST_DETAIL,
    page: () => PlayListDetailView(),
    binding: PlayListDetailBinding(),
    middlewares: [MusicBarMiddleware()],
  );

  static final _favorite = GetPage(
    name: Routes.FAVORITE,
    page: () => FavoritesView(),
    binding: FavoritesViewBinding(),
    middlewares: [MusicBarMiddleware()],
  );
}
