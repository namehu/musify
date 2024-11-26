import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/screens/common/myTextButton.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/util/httpclient.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';
import 'package:musify/views/album/album_controller.dart';
import 'package:musify/widgets/common/m_list_head.dart';
import 'package:musify/widgets/m_bottom_placeholder.dart';
import 'package:musify/widgets/m_button.dart';
import 'package:musify/widgets/m_cover.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:musify/widgets/m_text.dart';

class AlbumBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlbumController>(() => AlbumController());
  }
}

class AlbumView extends GetView<AlbumController> {
  // 顶部区域
  final double _toprightwidth =
      windowsWidth.value - screenImageWidthAndHeight - 40 - 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('专辑')),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopWidget()),
            SliverToBoxAdapter(child: _buildOperations()),
            SliverToBoxAdapter(child: _songsBody(context)),
            SliverToBoxAdapter(child: MBottomPlaceholder()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopWidget() {
    return MListHead(
      cover: Obx(
        () => MCover(
          url: controller.album.coverUrl,
          radius: 4,
        ),
      ),
      title: controller.album.title,
      subWidgets: [
        _buildTopUser(),
        Obx(
          () => controller.album.year != 0
              ? MText(
                  text:
                      S.current.year + ": " + controller.album.year.toString(),
                  style: nomalText,
                )
              : Container(),
        ),
        Obx(
          () => Container(
            child: MText(
              text:
                  S.current.song + ": " + controller.album.songCount.toString(),
              type: MTextTypeEnum.secondary,
            ),
          ),
        ),
        Obx(
          () => Container(
            child: MText(
              text: S.current.playCount +
                  ": " +
                  controller.album.playCount.toString(),
              type: MTextTypeEnum.secondary,
            ),
          ),
        ),
      ],
    );
  }

  _buildOperations() {
    return Container(
      padding: allPadding,
      child: Row(
        children: [
          Expanded(
              child: MButton(
            icon: Icons.play_arrow,
            title: S.current.playAll,
            onTap: () => controller.handlePlay(),
          )),
          SizedBox(width: 10),
          Expanded(
            child: MButton(
              icon: Icons.shuffle,
              title: S.current.playShuffle,
              type: ButtonType.secondary,
              onTap: () => controller.handlePlay(PlayModeEnum.shuffle),
            ),
          ),
        ],
      ),
    );
  }

  /// 歌手名称
  Widget _buildTopUser() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 歌手名
          Container(
            constraints: BoxConstraints(
              maxWidth: _toprightwidth,
            ),
            child: Obx(
              () => MText(
                onTap: () {
                  // TODO: 调整至歌手页面
                },
                text: controller.album.artist,
                type: MTextTypeEnum.secondary,
              ),
            ),
          ),
          // 收藏按钮
          Container(
            width: 25,
            child: MStarToogle(
              value: controller.staralbum.value,
              size: 16,
              onChange: (val) async {
                var _favorite = Favorite(id: activeID.value, type: 'album');
                controller.staralbum.value
                    ? await delStarred(_favorite)
                    : await addStarred(_favorite);
                controller.staralbum.value = !controller.staralbum.value;
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> mylistView(List<String> _title) {
    List<Widget> _list = [];
    for (var i = 0; i < _title.length; i++) {
      _list.add(Container(
        padding: EdgeInsets.only(left: 5),
        child: MyTextButton(
            press: () {
              // TODO: 点击处理
              // activeID.value = _title[i];
              // indexValue.value = 4;
            },
            title: _title[i]),
      ));
    }
    return _list;
  }

  Widget _songsBody(BuildContext _context) {
    return MediaQuery.removePadding(
      context: _context,
      removeTop: true,
      child: Obx(() => ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: controller.songs.length,
            itemExtent: 50.0, //强制高度为50.0
            itemBuilder: (BuildContext context, int index) {
              Songs _song = controller.songs[index];
              List<String> _title = [
                _song.title,
                formatDuration(_song.duration),
                _song.id
              ];
              return InkWell(
                onTap: () => controller.handleSongClick(_song, index),
                child: ListTile(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: _songlistView(
                      _title,
                      index,
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }

  List<Widget> _songlistView(
    List<String> _title,
    int _index,
  ) {
    var _id = _title[2];
    return _title.asMap().keys.map((i) {
      if (i == 0) {
        return Expanded(
          flex: 1,
          child: Obx(() {
            var active =
                controller.audioPlayerService.currentSong.value.id == _id;
            return Text(
              _title[i],
              textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: active
                    ? ThemeService.color.textPrimaryColor
                    : ThemeService.color.textColor,
              ),
            );
          }),
        );
      } else if (i == _title.length - 1) {
        return InkWell(
          onTap: () {
            print('还没做');
          },
          child: Icon(
            Icons.more_vert,
            size: 24,
            color: textGray,
          ),
        );
      }
      // 时长
      return Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Text(
          _title[i],
          textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: ThemeService.color.textSecondColor, fontSize: 12),
        ),
      );
    }).toList();
  }
}
