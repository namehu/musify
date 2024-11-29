// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/widgets/m_cover.dart';

import '../../models/myModel.dart';
import '../../models/notifierValue.dart';
import '../../util/mycss.dart';

class MySliverControlList extends StatelessWidget {
  final ScrollController controller;
  final List<Albums> albums;
  final double? height;

  const MySliverControlList({
    super.key,
    required this.controller,
    required this.albums,
    this.height = 250,
  });

  @override
  Widget build(BuildContext context) {
    var maxWidth = height! - 67;
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        controller: controller,
        itemBuilder: (context, index) {
          Albums albumItem = albums[index];

          String atitle = albumItem.title;
          if (albumItem.year != 0) {
            atitle = "${albumItem.title}(${albumItem.year})";
          }

          return Container(
            padding: index == 0 ? leftrightPadding : EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: () {
                activeID.value = albumItem.id;
                Get.toNamed(Routes.ALBUM, arguments: {'id': albumItem.id});
              },
              child: Column(
                children: [
                  Container(
                    constraints: BoxConstraints(maxHeight: maxWidth),
                    child: MCover(
                      url: albumItem.coverUrl,
                      size: maxWidth,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Text(
                      atitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Text(
                      albumItem.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ThemeService.color.textSecondColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
