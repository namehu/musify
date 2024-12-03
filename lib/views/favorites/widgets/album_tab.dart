import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/star_type_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';
import 'package:musify/views/favorites/favorites_controller.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:musify/widgets/m_table_list.dart';

class AlbumTab extends StatelessWidget {
  final controller = Get.find<FavoritesController>();

  final List<Albums> data;
  final List<bool> favs;

  AlbumTab({
    super.key,
    required this.data,
    required this.favs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHead(),
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: data.length,
          itemBuilder: (ctx, index) {
            var item = data[index];
            return _buildContent(item, index);
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
        MColumn(text: (S.current.artist)),
        MColumn(text: (S.current.song)),
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

  _buildContent(Albums data, int index) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.ALBUM,
          arguments: {'id': data.id},
        );
      },
      child: MTableList(
        data: [
          MColumn(flex: 1, text: data.title),
          MColumn(text: data.artist),
          MColumn(text: data.songCount.toString()),
          MColumn(
              text: formatDurationMilliseconds(data.duration), show: !isMobile),
          MColumn(text: data.playCount.toString(), show: !isMobile),
          MColumn(
            width: 50,
            child: MStarToogle(
              value: favs[index],
              onChange: (val) async {
                await controller.starService.toggleStar(
                  id: data.id,
                  type: StarTypeEnum.album,
                  star: val,
                );

                controller.albumsFav[index] = val;
              },
            ),
          ),
        ],
        divider: true,
      ),
    );
  }
}
