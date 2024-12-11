import 'package:get/get.dart';
import 'package:musify/constant.dart';
import 'package:musify/models/database/database.dart';
import 'package:musify/routes/pages.dart';

class ChangeServerViewController extends GetxController {
  final _serverList = <ServerTableData>[].obs;

  List<ServerTableData> get serverList => _serverList.value;

  @override
  void onInit() async {
    super.onInit();
    _serverList.value = await database.select(database.serverTable).get();
  }

  handleTap([ServerTableData? item]) {
    Get.toNamed(Routes.LOGIN, arguments: item);
  }
}
