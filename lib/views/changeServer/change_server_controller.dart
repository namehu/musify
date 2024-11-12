import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/util/dbProvider.dart';

class ChangeServerViewController extends GetxController {
  final _serverList = <ServerInfo>[].obs;

  List<ServerInfo> get serverList => _serverList.value;

  @override
  void onInit() async {
    super.onInit();

    _serverList.value = await DbProvider.instance.getServerList();
  }

  handleTap(ServerInfo item) {
    Get.toNamed(Routes.LOGIN, arguments: item);
  }
}
