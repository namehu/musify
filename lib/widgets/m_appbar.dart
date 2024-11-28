import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/util/mycss.dart';

class MAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;

  const MAppBar({super.key, this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: isMobile,
      leading: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      title: title,
      titleSpacing: 0,
      actions: actions,
    );
  }
}
