import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import '../../styles/size.dart';
import 'song_list_controller.dart';

class SongListBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SongListController());
  }
}

class SongListView extends GetView<SongListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.current.allSong)),
      body: Column(
        children: [
          Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: StyleSize.space),
            child: Text('111'),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: StyleSize.space),
                ),
                PagedSliverList<int, Songs>(
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    itemBuilder: (context, item, index) => _buildItem(item),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(top: StyleSize.space),
                    child: MBottomPlaceholder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Songs data) {
    return InkWell(
      onTap: () {
        // Get.toNamed(Routes.ALBUM, arguments: {'id': data.id});
      },
      child: Row(
        children: [
          Text(data.title),
          SizedBox(height: 5),
          Text(data.artist),
        ],
      ),
    );
  }
}
