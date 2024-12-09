import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/global_service.dart';
import 'package:musify/views/changeServer/change_server_controller.dart';
import 'package:musify/widgets/m_button.dart';

class ChangeServerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangeServerViewController());
  }
}

class ChangeServerView extends GetView<ChangeServerViewController> {
  const ChangeServerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.serverList),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: GloabalService.contentMaxWidth),
          child: Obx(
            () => ListView.separated(
              itemCount: controller.serverList.length,
              itemBuilder: (BuildContext context, int index) {
                var item = controller.serverList[index];

                return ListTile(
                    onTap: () => controller.handleTap(item),
                    // minTileHeight: 48,
                    leading: SizedBox(
                        height: 48,
                        child: Image.asset(
                          "assets/images/logo_navidrome.png",
                          height: 48,
                        )),
                    title: Text(
                      item.baseurl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(item.username),
                    trailing: Icon(Icons.keyboard_arrow_right_outlined));
              },
              separatorBuilder: (context, index) => SizedBox(height: 8),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 48 + 16,
        padding: EdgeInsets.all(8),
        child: Center(
          child: MButton(
            title: S.current.serverAdd,
            width: Platform.isWindows ? GloabalService.contentMaxWidth : null,
            onTap: () {
              controller.handleTap();
            },
          ),
        ),
      ),
    );
  }
}
