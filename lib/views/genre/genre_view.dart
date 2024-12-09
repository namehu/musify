import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/genres.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/widgets/m_table_list.dart';
import 'genre_controller.dart';

class GenreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenreController>(() => GenreController());
  }
}

class GenreView extends GetView<GenreController> {
  const GenreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: isMobile,
        title: Row(
          children: [
            Text(S.current.genres),
            Obx(() => Text(controller.genresnum)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHead(),
            Expanded(
              child: Obx(
                () => CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemCount: controller.genres.length,
                      itemBuilder: (ctx, index) {
                        return _buildItem(controller.genres[index]);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildHead() {
    return MTableList(data: [
      MColumn(text: S.current.name, flex: 1),
      MColumn(text: S.current.album, flex: 1),
      MColumn(text: S.current.song, flex: 1),
    ]);
  }

  _buildItem(Genres data) {
    return InkWell(
      onTap: () {
        // TODO: 跳转
      },
      child: MTableList(
        data: [
          MColumn(text: data.value, flex: 1),
          MColumn(text: data.albumCount.toString(), flex: 1),
          MColumn(text: data.songCount.toString(), flex: 1),
        ],
      ),
    );
  }
}
