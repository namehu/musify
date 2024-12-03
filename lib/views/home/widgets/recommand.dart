import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'slider_cover.dart';

class HomeRecommand extends StatefulWidget {
  final List<Albums> albums;
  const HomeRecommand({
    super.key,
    required this.albums,
  });

  @override
  State<HomeRecommand> createState() => _HomeRecommandState();
}

class _HomeRecommandState extends State<HomeRecommand> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

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
      margin: EdgeInsets.only(top: StyleSize.space),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (ctx, con) => Container(
              constraints: con,
              child: CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  height: height,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 300),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: widget.albums.asMap().entries.map((item) {
                  return ClipRRect(
                    borderRadius:
                        BorderRadius.circular(StyleSize.smallBorderRadius),
                    child: Stack(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: MCover(url: item.value.coverUrl),
                        ),
                        ClipRect(
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                            child: SliderCover(
                              data: item.value,
                              size: coverSize,
                              active: item.key == _current,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(
            height:
                GetPlatform.isMobile ? StyleSize.spaceSmall : StyleSize.space,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.albums.asMap().entries.map((entry) {
              return InkWell(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: _current == entry.key ? 10 : 6.0,
                  height: _current == entry.key ? 10 : 6.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.8 : 0.2)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
