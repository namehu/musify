import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/theme_service.dart';
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
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined))
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: StyleSize.space),
              decoration: BoxDecoration(
                color: ThemeService.color.bgColor,
                boxShadow: [
                  BoxShadow(
                    color: ThemeService.color.borderColor,
                    blurRadius: 2,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: DropdownButtonHideUnderline(
                      child: Obx(
                        () => DropdownButton(
                          value: controller.selectOrder.value,
                          items: controller.sortOrder,
                          onChanged: (value) {
                            controller.selectOrder(value);
                          },
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 5),
                  //   child: VerticalDivider(
                  //     width: 1,
                  //     endIndent: 10,
                  //     indent: 10,
                  //     color: ThemeService.color.borderColor,
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: () {
                  //     controller.pagingController.refresh();
                  //   },
                  //   icon: Icon(
                  //     Icons.sort_rounded,
                  //     color: ThemeService.color.textColor,
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: VerticalDivider(
                      width: 1,
                      endIndent: 10,
                      indent: 10,
                      color: ThemeService.color.borderColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.pagingController.refresh();
                    },
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: ThemeService.color.textColor,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
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
            ),
          ],
        ));
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
