import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/util/httpClient.dart';
import 'package:musify/views/artists/artists_controller.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:musify/widgets/m_table_list.dart';
import 'package:musify/widgets/m_toast.dart';

import '../../util/mycss.dart';

class ArtistsViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArtistsController());
  }
}

class ArtistsView extends GetView<ArtistsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isMobile,
        title: Text(S.current.artist),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHead(),
          ),
          Obx(
            () => SliverList.builder(
              itemCount: controller.artists.length,
              itemBuilder: (ctx, index) {
                return _buildItem(index);
              },
            ),
          ),
          SliverToBoxAdapter(child: MBottomPlaceholder()),
        ],
      ),
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

  _buildItem(int index) {
    var item = controller.artists[index];

    return InkWell(
      onTap: () {
        Get.toNamed(Routes.ARTIST_DETAIL, arguments: {'id': item.id});
      },
      child: MTableList(
        data: [
          MColumn(flex: 1, text: item.name),
          MColumn(text: item.albumCount.toString()),
          MColumn(
            text: S.current.favorite,
            width: 50,
            child: Obx(
              () => MStarToogle(
                value: controller.star[index],
                onChange: (value) async {
                  Favorite _favorite = Favorite(id: item.id, type: 'artist');
                  if (value) {
                    await addStarred(_favorite);
                    MToast.show(S.current.add + S.current.favorite);
                  } else {
                    await delStarred(_favorite);
                    MToast.show(S.current.cancel + S.current.favorite);
                  }

                  controller.star[index] = value;
                },
              ),
            ),
          ),
        ],
        divider: true,
      ),
    );
  }
}
