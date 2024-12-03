import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/album_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_title.dart';

import '../../../styles/colors.dart';

class SliderCover extends StatefulWidget {
  final Albums data;
  final double size;
  final bool active;
  const SliderCover({
    super.key,
    required this.data,
    required this.size,
    required this.active,
  });

  @override
  State<SliderCover> createState() => _SliderCoverState();
}

class _SliderCoverState extends State<SliderCover> {
  bool showPlayButton = false;

  handleSlideClick(String id) {
    Get.toNamed(Routes.ALBUM, arguments: {'id': id});
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.data;
    var space = isMobile ? StyleSize.spaceSmall : StyleSize.spaceLarge;

    return MouseRegion(
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
      child: InkWell(
        onTap: () {
          handleSlideClick(item.id);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? space : space + space,
            horizontal: space,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
          ),
          child: Row(
            children: [
              // SliderCover(
              //   data: item,
              //   size: coverSize,
              // ),
              _buildCover(),
              SizedBox(width: space),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: StyleSize.spaceSmall,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText(
                        item.title,
                        isMobile ? 20 : 30,
                      ),
                      if (widget.active) SizedBox(height: StyleSize.spaceSmall),
                      _buildText(
                        item.artist,
                        isMobile ? 16 : 24,
                      ),
                      if (widget.active) SizedBox(height: StyleSize.spaceSmall),
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
      ),
    );
  }

  _buildText(String text, [double size = 24]) {
    return LayoutBuilder(
      builder: (ctx, con) {
        return Container(
          constraints: BoxConstraints(maxWidth: con.maxWidth),
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
      },
    );
  }

  _buildCover() {
    return Container(
      decoration: BoxDecoration(
        color: gray4,
        borderRadius: BorderRadius.circular(StyleSize.borderRadius),
      ),
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
    );
  }
}
