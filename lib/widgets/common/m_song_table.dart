import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../models/songs.dart';
import '../../util/mycss.dart';
import '../../util/util.dart';
import '../m_table_list.dart';

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
        MColumn(text: (S.current.artist)),
        MColumn(text: (S.current.duration)),
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
      child: MTableList(
        data: [
          MColumn(flex: 1, text: (song.title)),
          MColumn(
            text: song.album,
            width: 150,
            show: !isMobile,
          ),
          MColumn(text: (song.artist)),
          MColumn(text: (formatDuration(song.duration))),
          MColumn(
            text: (song.suffix + "(" + song.bitRate.toString() + ")"),
            show: !isMobile,
          ),
          MColumn(
            text: (song.playCount.toString()),
            show: !isMobile,
          ),
        ],
      ),
    );
  }
}
