import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';

import '../../generated/l10n.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';
import 'myTextButton.dart';

class MySliverControlBar extends StatelessWidget {
  final String title;
  final controller;
  final press;

  const MySliverControlBar(
      {Key? key, required this.title, required this.controller, this.press});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: allPadding,
      height: 25,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: StyleSize.titleSize,
                  color: ThemeService.color.titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (press != null) SizedBox(width: 5),
              if (press != null)
                MyTextButton(
                  press: press,
                  title: S.current.more,
                )
            ]),
            if (!isMobile)
              Row(
                children: [
                  InkWell(
                    child: Icon(
                      Icons.chevron_left,
                      color: ThemeService.color.textColor,
                    ),
                    onTap: () {
                      controller.animateTo(
                        controller.offset - windowsWidth.value / 2,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease,
                      );
                    },
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    child: Icon(
                      Icons.chevron_right,
                      color: ThemeService.color.textColor,
                    ),
                    onTap: () {
                      controller.animateTo(
                        controller.offset + windowsWidth.value / 2,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.ease,
                      );
                    },
                  )
                ],
              )
          ]),
    );
  }
}
