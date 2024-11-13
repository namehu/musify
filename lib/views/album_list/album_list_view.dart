import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'album_list_controller.dart';

class AlbumListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlbumListController());
  }
}

class AlbumListView extends GetView<AlbumListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('AlbumListView')),
        body: SafeArea(child: Text('AlbumListViewController')));
  }
}
