import 'package:get/get.dart';
import 'package:musify/routes/middlewares.dart';
import 'package:musify/views/album/album_view.dart';
import 'package:musify/views/album_list/album_list_view.dart';
import 'package:musify/views/changeServer/change_server_view.dart';
import 'package:musify/views/login/login_view.dart';
import 'package:musify/views/play/play_view.dart';
import 'package:musify/views/play_list/play_list_binding.dart';
import 'package:musify/views/play_list/play_list_view.dart';
import 'package:musify/views/setting/setting_view.dart';

import '../views/home/home_view.dart';
import '../views/home/home_view_pc.dart';
import '../views/home/home_view_binding.dart';

part 'routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      binding: HomeViewBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginViewBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.CHANGE_SERVER,
      page: () => ChangeServerView(),
      binding: ChangeServerBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.SETTING,
      page: () => SettingView(),
      binding: SettingBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.ALBUM_LIST,
      page: () => AlbumListView(),
      binding: AlbumListBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.ALBUM,
      page: () => AlbumView(),
      binding: AlbumBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.PLAY,
      page: () => PlayView(),
      binding: PlayBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.PLAY_LIST,
      page: () => PlayListView(),
      binding: PlayListBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
  ];

  static final pagesPC = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeViewPC(),
      binding: HomeViewBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginViewBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.CHANGE_SERVER,
      page: () => ChangeServerView(),
      binding: ChangeServerBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.SETTING,
      page: () => SettingView(),
      binding: SettingBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.ALBUM_LIST,
      page: () => AlbumListView(),
      binding: AlbumListBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.ALBUM,
      page: () => AlbumView(),
      binding: AlbumBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.PLAY,
      page: () => PlayView(),
      binding: PlayBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
    GetPage(
      name: Routes.PLAY_LIST,
      page: () => PlayListView(),
      binding: PlayListBinding(),
      middlewares: [MusicBarMiddleware()],
    ),
  ];
}
