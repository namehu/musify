import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/views/changeServer/change_server_controller.dart';

class ChangeServerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangeServerViewController());
  }
}

class ChangeServerView extends GetView<ChangeServerViewController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('服务器列表')),
      body: ListView.separated(
        itemCount: controller.serverList.length,
        itemBuilder: (BuildContext context, int index) {
          var item = controller.serverList[index];

          return ListTile(
              onTap: () => controller.handleTap(item),
              // minTileHeight: 48,
              leading: Container(
                  height: 48,
                  child: Image.asset(
                    "assets/images/logo_navidrome.png",
                    height: 48,
                  )),
              title: Text(
                '${item.baseurl}${item.baseurl}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(item.username),
              trailing: Icon(Icons.keyboard_arrow_right_outlined));
        },
        separatorBuilder: (context, index) => SizedBox(height: 8),
      ),
    );
  }
}
