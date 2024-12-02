import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/services/album_servrice.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/widgets/m_cover.dart';

import '../../../styles/colors.dart';

class SliderCover extends StatefulWidget {
  final Albums data;
  final double size;
  const SliderCover({
    super.key,
    required this.data,
    required this.size,
  });

  @override
  State<SliderCover> createState() => _SliderCoverState();
}

class _SliderCoverState extends State<SliderCover> {
  bool showPlayButton = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: gray4,
        borderRadius: BorderRadius.circular(StyleSize.borderRadius),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          setState(() {
            showPlayButton = true;
          });
        },
        onExit: (event) {
          setState(() {
            showPlayButton = false;
          });
        },
        child: Stack(
          children: [
            MCover(
              url: widget.data.coverUrl,
              size: widget.size,
            ),
            if (showPlayButton && GetPlatform.isDesktop)
              SizedBox(
                height: widget.size,
                width: widget.size,
                child: Center(
                  child: IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        gray4,
                      ),
                    ),
                    onPressed: () {
                      Get.find<AlbumServrice>().playAlbum(widget.data.id);
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      size: widget.size / 4,
                      color: ThemeService.color.textColor,
                    ),
                  ),
                ),
              ),
            if (GetPlatform.isMobile)
              Container(
                alignment: Alignment.bottomRight,
                height: widget.size,
                width: widget.size,
                child: IconButton(
                  onPressed: () {
                    Get.find<AlbumServrice>().playAlbum(widget.data.id);
                  },
                  icon: Icon(
                    Icons.play_arrow_rounded,
                    size: widget.size / 4,
                    color: gray1,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
