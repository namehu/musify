import 'package:get/get.dart';
import 'package:musify/mainScreen.dart';
import 'package:musify/views/album_list/album_list_view.dart';
import 'package:musify/views/changeServer/change_server_view.dart';
import 'package:musify/views/login/login_view.dart';
import 'package:musify/views/setting/setting_view.dart';

part 'routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => MainScreen(),
      binding: HomeViewBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginViewBinding(),
    ),
    GetPage(
      name: Routes.CHANGE_SERVER,
      page: () => ChangeServerView(),
      binding: ChangeServerBinding(),
    ),
    GetPage(
      name: Routes.SETTING,
      page: () => SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: Routes.ALBUM_LIST,
      page: () => AlbumListView(),
      binding: AlbumListBinding(),
    ),
  ];
}
