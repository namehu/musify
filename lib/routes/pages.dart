import 'package:get/get.dart';
import 'package:musify/mainScreen.dart';
import 'package:musify/screens/login.dart';

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
  ];
}
