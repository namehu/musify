import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService extends GetxService {
  static late SharedPreferences instance;

  Future<PreferencesService> init() async {
    instance = await SharedPreferences.getInstance();
    return this;
  }
}
