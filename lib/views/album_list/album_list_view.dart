import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/widgets/m_cover.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: isMobile,
        title: Text(S.current.album),
      ),
      body: CustomScrollView(
        slivers: [
          PagedSliverMasonryGrid<int, Albums>.extent(
            pagingController: controller.pagingController,
            maxCrossAxisExtent: 200,
            crossAxisSpacing: StyleSize.space,
            mainAxisSpacing: StyleSize.space,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) => _buildItem(item),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Albums data) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.ALBUM, arguments: {'id': data.id});
      },
      child: Column(
        children: [
          MCover(url: data.coverUrl),
          SizedBox(height: 5),
          Text(data.title),
          SizedBox(height: 5),
          Text(data.artist),
        ],
      ),
    );
  }
}
