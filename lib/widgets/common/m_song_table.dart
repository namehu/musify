import 'package:flutter/material.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/widgets/m_cover.dart';

import '../../generated/l10n.dart';
import '../../models/songs.dart';
import '../../util/mycss.dart';
import '../../util/util.dart';
import '../m_table_list.dart';
import '../m_text.dart';

class MSongTableHead extends StatelessWidget {
  const MSongTableHead({super.key});

  @override
  Widget build(BuildContext context) {
    return MTableList(
      isHead: true,
      data: [
        MColumn(flex: 1, text: S.current.song),
        MColumn(
          text: (S.current.album),
          width: 150,
          show: !isMobile,
        ),
        MColumn(child: Icon(Icons.access_time_outlined, size: 14)),
        MColumn(text: (S.current.bitRange), show: !isMobile),
        MColumn(text: (S.current.playCount), show: !isMobile),
      ],
      divider: true,
    );
  }
}

class MSongTableRow extends StatelessWidget {
  final Songs song;
  final int index;
  final void Function()? onTap;

  final double _coverSize = 48;
  final double contentPadding = StyleSize.spaceSmall;

  MSongTableRow({
    super.key,
    required this.song,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        height: StyleSize.listItemLargeHeight,
        child: MTableList(
          data: [
            MColumn(
              flex: 1,
              child: LayoutBuilder(builder: (ctx, constraints) {
                var _maxWidth =
                    constraints.maxWidth - _coverSize - contentPadding * 2 - 5;
                return Container(
                  child: Row(
                    children: [
                      MCover(
                        size: _coverSize,
                        url: song.coverUrl,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: contentPadding,
                          vertical: StyleSize.spaceSmall + 2,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: _maxWidth),
                              child: MText(text: song.title, maxLines: 1),
                            ),
                            MText(
                              text: song.artist,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 13,
                                color: ThemeService.color.textSecondColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            MColumn(
              text: song.album,
              width: 200,
              show: !isMobile,
            ),
            MColumn(text: (formatDuration(song.duration))),
            MColumn(
              text: (song.suffix + " / " + song.bitRate.toString() + 'k'),
              show: !isMobile,
            ),
            MColumn(
              text: (song.playCount.toString()),
              show: !isMobile,
            ),
          ],
        ),
      ),
    );
  }
}
