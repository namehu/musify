import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/star_type_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/views/artists/artists_controller.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:musify/widgets/m_table_list.dart';
import 'package:musify/widgets/sliver/sliver_header_delegate.dart';

import '../../util/mycss.dart';

class ArtistsViewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArtistsController());
  }
}

class ArtistsView extends GetView<ArtistsController> {
  const ArtistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isMobile,
        title: Text(S.current.artist),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverHeaderDelegate(
              maxHeight: 48,
              minHeight: 48,
              child: _buildHead(),
            ),
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
    return Container(
      color: ThemeService.color.bgColor,
      child: MTableList(
        isHead: true,
        data: [
          MColumn(text: '#', width: 48),
          MColumn(flex: 1, text: S.current.artist),
          MColumn(
            text: '',
            width: 50,
          ),
        ],
        divider: true,
      ),
    );
  }

  _buildItem(int index) {
    var item = controller.artists[index];

    return InkWell(
      onTap: () {
        Get.toNamed(Routes.ARTIST_DETAIL, arguments: {'id': item.id});
      },
      child: SizedBox(
        height: StyleSize.listItemLargeHeight,
        child: MTableList(
          data: [
            MColumn(text: (index + 1).toString().padLeft(2, '0'), width: 48),
            MColumn(flex: 1, child: _buildMainColumn(item)),
            MColumn(
              text: S.current.favorite,
              width: 50,
              child: Obx(
                () => MStarToogle(
                  value: controller.star[index],
                  onChange: (value) async {
                    await controller.starService.toggleStar(
                      id: item.id,
                      type: StarTypeEnum.artist,
                      star: value,
                    );

                    controller.star[index] = value;
                  },
                ),
              ),
            ),
          ],
          divider: true,
        ),
      ),
    );
  }

  _buildMainColumn(Artists data) {
    return Row(
      children: [
        MCover(
          url: data.artistImageUrl,
          size: 48,
        ),
        SizedBox(
          width: StyleSize.space,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: StyleSize.spaceSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${S.current.album} ${data.albumCount.toString()}',
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeService.color.textSecondColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
