import 'package:get/get.dart';
import 'package:musify/dao/server_info_repository.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';

class ChangeServerViewController extends GetxController {
  final _serverList = <ServerInfo>[].obs;

  List<ServerInfo> get serverList => _serverList.value;

  @override
  void onInit() async {
    super.onInit();

    _serverList.value = await ServerInfoRepository().getServerList();
  }

  handleTap([ServerInfo? item]) {
    Get.toNamed(Routes.LOGIN, arguments: item);
  }
}
