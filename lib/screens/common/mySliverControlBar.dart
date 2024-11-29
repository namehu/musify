// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/widgets/m_title.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';

class MySliverControlBar extends StatelessWidget {
  final String title;
  final ScrollController controller;

  const MySliverControlBar(
      {super.key, required this.title, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: StyleProperty.allPadding,
      height: 25,
      child: MTitle(
        title: title,
        actions: isMobile
            ? []
            : [
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
      ),
    );
  }
}
