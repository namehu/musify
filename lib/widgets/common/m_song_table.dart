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

const double _albumWidth = 200;
const double _indexWidth = 36;

class MSongTableHead extends StatelessWidget {
  final bool? showIndex;
  const MSongTableHead({
    super.key,
    this.showIndex = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeService.color.secondBgColor,
      child: LayoutBuilder(
        builder: (ctx, con) {
          return MTableList(
            isHead: true,
            data: [
              MColumn(text: '#', width: _indexWidth, show: showIndex),
              MColumn(flex: 1, text: S.current.song),
              MColumn(
                text: (S.current.album),
                width: _albumWidth,
                show: !isMobile,
              ),
              MColumn(child: Icon(Icons.access_time_outlined, size: 14)),
              MColumn(
                text: S.current.bitRange,
                show: !isMobile && con.maxWidth > 700,
              ),
              MColumn(
                text: S.current.playCount,
                show: !isMobile && con.maxWidth > 700,
              ),
            ],
            divider: true,
          );
        },
      ),
    );
  }
}

class MSongTableRow extends StatelessWidget {
  final Songs song;
  final int index;
  final bool? showIndex;
  final bool? active;
  final void Function()? onTap;

  final double _coverSize = 48;
  final double contentPadding = StyleSize.spaceSmall;

  const MSongTableRow({
    super.key,
    required this.song,
    required this.index,
    this.showIndex = true,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var activeColor = Colors.red[400];
    // var color = active! ? ThemeService.color.primaryColor : null;
    return InkWell(
      onTap: () async {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        color: ThemeService.color.secondBgColor,
        height: StyleSize.listItemLargeHeight,
        child: LayoutBuilder(builder: (ctx, con) {
          return MTableList(
            data: [
              MColumn(
                child: active!
                    ? Icon(Icons.music_note_outlined, color: activeColor)
                    : Text(
                        (index + 1).toString().padLeft(2, '0'),
                        style: TextStyle(
                          color: ThemeService.color.textSecondColor,
                        ),
                      ),
                width: _indexWidth,
                show: showIndex,
              ),
              MColumn(
                flex: 1,
                child: LayoutBuilder(builder: (ctx, constraints) {
                  var maxWidth = constraints.maxWidth -
                      _coverSize -
                      contentPadding * 2 -
                      5;
                  return Row(
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
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: MText(
                                text: song.title,
                                maxLines: 1,
                                style: TextStyle(
                                    color: active! ? activeColor : null),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: MText(
                                text: song.artist,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: active!
                                      ? activeColor
                                      : ThemeService.color.textSecondColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
              MColumn(
                text: song.album,
                width: _albumWidth,
                show: !isMobile,
              ),
              MColumn(
                  child: Text(
                formatDuration(song.duration),
                style: TextStyle(
                  color: active! ? activeColor : null,
                ),
              )),
              MColumn(
                text: ("${song.suffix} / ${song.bitRate.toString()}k"),
                show: !isMobile && con.maxWidth > 700,
              ),
              MColumn(
                text: (song.playCount.toString()),
                show: !isMobile && con.maxWidth > 700,
              ),
            ],
          );
        }),
      ),
    );
  }
}
