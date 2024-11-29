import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/util/httpclient.dart';
import 'package:musify/views/favorites/favorites_controller.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:musify/widgets/m_table_list.dart';
import 'package:musify/widgets/m_toast.dart';

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
        // TODO: 挑战未做
        // Get.toNamed(
        //   Routes.ALBUM,
        //   arguments: {'id': data.id},
        // );
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
                Favorite favorite = Favorite(id: data.id, type: 'artist');
                if (val) {
                  await addStarred(favorite);
                  MToast.show(S.current.add + S.current.favorite);
                } else {
                  await delStarred(favorite);
                  MToast.show(S.current.cancel + S.current.favorite);
                }

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
