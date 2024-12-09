import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/enums/album_list_type_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/widgets/m_appbar.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import 'package:musify/widgets/m_cover.dart';
import 'album_list_controller.dart';
import 'widgets/icon_more.dart';

class AlbumListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlbumListController());
  }
}

class AlbumListView extends GetView<AlbumListController> {
  const AlbumListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MAppBar(
          title: Text(S.current.album),
          actions: [
            if (isMobile) IconMore(),
          ],
        ),
        body: Column(
          children: [
            if (!isMobile)
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
                    DropdownButtonHideUnderline(
                      child: Obx(
                        () => DropdownButton<AlbumListTypeEnum>(
                          value: controller.selectOrder.value,
                          items: controller.sortOrderList
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e[0] as AlbumListTypeEnum,
                                  child: Text(e[1] as String),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            controller.selectOrder(value);
                          },
                        ),
                      ),
                    ),
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
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: StyleSize.space),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(height: StyleSize.space),
                    ),
                    PagedSliverMasonryGrid<int, Albums>.extent(
                      pagingController: controller.pagingController,
                      maxCrossAxisExtent: isMobile ? 150 : 200,
                      crossAxisSpacing: StyleSize.space,
                      mainAxisSpacing: StyleSize.space,
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: (context, item, index) => _buildItem(item),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: EdgeInsets.only(top: StyleSize.space),
                        child: MBottomPlaceholder(),
                      ),
                    ),
                  ],
                ),
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
