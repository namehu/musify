import 'dart:io';

import 'package:get/get.dart';

class GloabalService extends GetxService {
  /// 是否是客户端
  static final isClient =
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  /// 是否是移动端
  static final isPhone = Platform.isAndroid || Platform.isIOS;

  /// 内容区最大宽度
  static final double contentMaxWidth =
      GloabalService.isPhone ? Get.width : 564;

  Future<GloabalService> init() async {
    return this;
  }
}
