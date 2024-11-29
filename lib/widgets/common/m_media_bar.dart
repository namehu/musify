import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';

import 'package:musify/widgets/m_appbar.dart';

class MMediaBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? title;
  final int? count;
  final void Function()? onPlayClick;

  const MMediaBar({super.key, this.title, this.count = 0, this.onPlayClick});

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  State<MMediaBar> createState() => _MMediaBarState();
}

class _MMediaBarState extends State<MMediaBar> {
  @override
  Widget build(BuildContext context) {
    return MAppBar(
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          if (!isMobile) _buildPlay(),
          if (!isMobile) SizedBox(width: StyleSize.space),
          if (widget.title != null) widget.title!,
          if (!isMobile) SizedBox(width: StyleSize.space),
          if (!isMobile && widget.count! > 0) _buildCount(),
        ],
      ),
    );
  }

  _buildPlay() {
    return InkWell(
      onTap: () {
        if (widget.onPlayClick != null) {
          widget.onPlayClick!();
        }
      },
      child: Icon(
        Icons.play_circle,
        size: 42,
        color: ThemeService.mode.value == ThemeMode.dark
            ? Colors.white
            : Colors.white,
      ),
    );
  }

  _buildCount() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      decoration: BoxDecoration(
          color: ThemeService.color.cardColor,
          borderRadius: BorderRadius.all(Radius.circular(2))),
      child: Text(
        widget.count!.toString(),
        style:
            TextStyle(fontSize: 12, color: ThemeService.color.textSecondColor),
      ),
    );
  }
}
