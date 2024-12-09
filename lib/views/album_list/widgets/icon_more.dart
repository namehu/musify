import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/constant.dart';
import 'package:musify/enums/album_list_type_enum.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/views/album_list/album_list_controller.dart';
import 'package:popover/popover.dart';

class IconMore extends StatelessWidget {
  final controller = Get.find<AlbumListController>();

  IconMore({super.key});

  double get maxheight => (32 * controller.sortOrderList.length +
          16 * (controller.sortOrderList.length - 1) +
          20)
      .toDouble();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: appBarActionWith,
      child: GestureDetector(
        child: Icon(Icons.more_vert),
        onTap: () async {
          await showPopover(
            context: context,
            constraints: BoxConstraints(maxHeight: maxheight),
            width: 150,
            backgroundColor: ThemeService.color.dialogBackgroundColor,
            direction: PopoverDirection.bottom,
            bodyBuilder: (_) => Padding(
              padding: const EdgeInsets.all(10),
              child: _buildList(context),
            ),
          );
        },
      ),
    );
  }

  _buildList(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.separated(
          itemCount: controller.sortOrderList.length,
          separatorBuilder: (c, i) => Divider(),
          itemBuilder: (ctx, i) {
            var sortOrderItem = controller.sortOrderList[i];
            return GestureDetector(
              child: Container(
                height: StyleSize.listItemSmallHeight,
                alignment: Alignment.center,
                child: Text(sortOrderItem[1] as String),
              ),
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
                controller.selectOrder(sortOrderItem[0] as AlbumListTypeEnum);
              },
            );
          },
        ));
  }
}
