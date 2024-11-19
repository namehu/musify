import 'package:flutter/material.dart';
import 'package:musify/constant.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';

class MBottomPlaceholder extends StatelessWidget {
  const MBottomPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: bottomHeight),
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100,
              child: Divider(
                height: 1,
                color: ThemeService.color.borderColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: StyleSize.spaceSmall, right: StyleSize.spaceSmall),
              child: Text(
                '已经到底啦~',
                style: TextStyle(color: ThemeService.color.textSecondColor),
              ),
            ),
            SizedBox(
              width: 100,
              child: Divider(
                height: 1,
                color: ThemeService.color.borderColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
