import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:musify/widgets/m_title.dart';
import 'slider_cover.dart';

class HomeRecommand extends StatelessWidget {
  final List<Albums> albums;
  const HomeRecommand({
    super.key,
    required this.albums,
  });

  handleSlideClick(String id) {
    Get.toNamed(Routes.ALBUM, arguments: {'id': id});
  }

  @override
  Widget build(BuildContext context) {
    var space = isMobile ? StyleSize.spaceSmall : StyleSize.spaceLarge;
    double height = isMobile ? 150 : 280.0;

    double containerVerticalPadding = isMobile ? space : space + space;
    double coverSize = height - containerVerticalPadding * 2;

    return Container(
      margin: StyleProperty.allPadding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(StyleSize.borderRadius),
        child: LayoutBuilder(
          builder: (ctx, con) => Container(
            constraints: con,
            child: CarouselSlider(
              options: CarouselOptions(
                height: height,
                viewportFraction: 1,
              ),
              items: albums.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return SizedBox(
                      width: con.maxWidth,
                      child: Stack(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: MCover(url: item.coverUrl),
                          ),
                          SizedBox.expand(
                            child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 50.0, sigmaY: 50.0),
                                child: InkWell(
                                  onTap: () {
                                    handleSlideClick(item.id);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          isMobile ? space : space + space,
                                      horizontal: space,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                    child: Row(
                                      children: [
                                        SliderCover(
                                          data: item,
                                          size: coverSize,
                                        ),
                                        SizedBox(width: space),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: StyleSize.spaceSmall,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _buildText(
                                                  item.title,
                                                  isMobile ? 24 : 30,
                                                ),
                                                SizedBox(
                                                  height: StyleSize.spaceSmall,
                                                ),
                                                _buildText(item.artist),
                                                SizedBox(
                                                  height: StyleSize.spaceSmall,
                                                ),
                                                MTitle(
                                                  level: 6,
                                                  title:
                                                      '${S.current.song}: ${item.songCount}   ${S.current.playCount}: ${item.playCount}',
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  _buildText(String text, [double size = 24]) {
    return LayoutBuilder(builder: (ctx, con) {
      return Container(
        constraints: con,
        child: Text(
          text,
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    });
  }
}
