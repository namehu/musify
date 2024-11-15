import 'package:get/get.dart';
import 'package:musify/routes/middlewares.dart';
import 'package:musify/views/album/album_view.dart';
import 'package:musify/views/home/home_view.dart';
import 'package:musify/views/album_list/album_list_view.dart';
import 'package:musify/views/changeServer/change_server_view.dart';
import 'package:musify/views/login/login_view.dart';
import 'package:musify/views/setting/setting_view.dart';

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
    )
  ];
}
