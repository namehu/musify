import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/star_type_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/views/favorites/favorites_controller.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:musify/widgets/m_table_list.dart';

import '../../../routes/pages.dart';

class ArtistTab extends StatelessWidget {
  final controller = Get.find<FavoritesController>();

  final List<Artists> data;
  final List<bool> favs;

  ArtistTab({
    super.key,
    required this.data,
    required this.favs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHead(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              var item = data[index];
              return _buildContent(item, index);
            },
          ),
        ),
      ],
    );
  }

  _buildHead() {
    return MTableList(
      isHead: true,
      data: [
        MColumn(flex: 1, text: S.current.artist),
        MColumn(text: (S.current.album)),
        MColumn(
          text: S.current.favorite,
          width: 50,
        ),
      ],
      divider: true,
    );
  }

  _buildContent(Artists data, int index) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.ARTIST_DETAIL,
          arguments: {'id': data.id},
        );
      },
      child: MTableList(
        data: [
          MColumn(flex: 1, text: data.name),
          MColumn(text: data.albumCount.toString()),
          MColumn(
            width: 50,
            child: MStarToogle(
              value: favs[index],
              onChange: (val) async {
                await controller.starService.toggleStar(
                  id: data.id,
                  type: StarTypeEnum.artist,
                  star: val,
                );

                controller.artistsFav[index] = val;
              },
            ),
          ),
        ],
        divider: true,
      ),
    );
  }
}
