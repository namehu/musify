import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/star_type_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';
import 'package:musify/views/favorites/favorites_controller.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:musify/widgets/m_table_list.dart';

class SongTab extends StatelessWidget {
  final audioPlayerService = Get.find<AudioPlayerService>();
  final controller = Get.find<FavoritesController>();

  final List<Songs> songs;
  final List<bool> songsFav;

  SongTab({
    super.key,
    required this.songs,
    required this.songsFav,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildHead(),
        ),
        SliverList.builder(
          itemCount: songs.length,
          itemBuilder: (ctx, index) {
            var data = songs[index];
            return _buildContent(data, index);
          },
        )
      ],
    );
  }

  _buildHead() {
    return MTableList(
      isHead: true,
      data: [
        MColumn(flex: 1, text: S.current.song),
        MColumn(text: (S.current.album)),
        MColumn(text: (S.current.artist)),
        MColumn(text: (S.current.bitRange), show: !isMobile),
        MColumn(text: (S.current.duration), show: !isMobile),
        MColumn(text: (S.current.playCount), show: !isMobile),
        MColumn(
          text: S.current.favorite,
          width: 50,
        ),
      ],
      divider: true,
    );
  }

  _buildContent(Songs data, int index) {
    return InkWell(
      onTap: () {
        audioPlayerService.palySongList(songs, index: index);
      },
      child: MTableList(
        data: [
          MColumn(flex: 1, text: data.title),
          MColumn(text: data.album),
          MColumn(text: data.artist),
          MColumn(text: data.bitRate.toString(), show: !isMobile),
          MColumn(
              text: formatDurationMilliseconds(data.duration), show: !isMobile),
          MColumn(text: data.playCount.toString(), show: !isMobile),
          MColumn(
            width: 50,
            child: MStarToogle(
              value: songsFav[index],
              onChange: (val) async {
                await controller.starService.toggleStar(
                  id: data.id,
                  type: StarTypeEnum.song,
                  star: val,
                );

                controller.songsFav[index] = val;
              },
            ),
          ),
        ],
        divider: true,
      ),
    );
  }
}
