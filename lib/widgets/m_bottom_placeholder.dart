import 'package:flutter/material.dart';
import 'package:musify/constant.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';

class MBottomPlaceholder extends StatelessWidget {
  const MBottomPlaceholder({
    super.key,
    this.extraMargin = const [32.0, 0.0],
  });

  final List<double>? extraMargin;

  @override
  Widget build(BuildContext context) {
    var top = extraMargin![0];
    var bottom = extraMargin!.length > 1 ? extraMargin![1] : extraMargin![0];

    return Column(children: [
      Container(
        margin: EdgeInsets.only(
          top: top,
          bottom: bottom,
        ),
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 48,
              child: Divider(
                height: 1,
                color: ThemeService.color.borderColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: StyleSize.spaceSmall, right: StyleSize.spaceSmall),
              child: Text(
                S.current.reachBottom,
                style: TextStyle(color: ThemeService.color.textSecondColor),
              ),
            ),
            SizedBox(
              width: 48,
              child: Divider(
                height: 1,
                color: ThemeService.color.borderColor,
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: isMobile ? bottomHeight : 0,
      )
    ]);
  }
}
