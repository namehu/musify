import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/models/songs.dart';
import 'package:musify/screens/common/myTextButton.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/httpclient.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/util.dart';
import 'package:musify/views/album/album_controller.dart';
import 'package:musify/widgets/m_button.dart';
import 'package:musify/widgets/m_star_toogle.dart';
import 'package:transparent_image/transparent_image.dart';

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
          ],
        ),
      ),
    );
  }

  Widget _buildTopWidget() {
    return Container(
      margin: EdgeInsets.only(top: StyleSize.space),
      padding: leftrightPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 封面
          Container(
            height: 136,
            width: 136,
            margin: EdgeInsets.only(right: 15),
            child: Obx(
              () => (controller.album.coverUrl != '')
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: controller.album.coverUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
            ),
          ),
          // 右侧区域
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    controller.album.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleText2,
                  ),
                ),
                _buildTopUser(),
                Obx(
                  () => controller.album.genre != ""
                      ? Container(
                          width: _toprightwidth,
                          child: Row(
                            children: [
                              MyTextButton(
                                press: () {
                                  indexValue.value = 6;
                                },
                                title: S.current.genres,
                              ),
                              SizedBox(width: 5),
                              MyTextButton(
                                press: () {
                                  activeID.value = controller.album.genre;
                                  indexValue.value = 4;
                                },
                                title: controller.album.genre,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ),
                Obx(
                  () => controller.album.year != 0
                      ? Container(
                          width: _toprightwidth,
                          child: Text(
                            S.current.year +
                                ": " +
                                controller.album.year.toString(),
                            style: nomalText,
                          ),
                        )
                      : Container(),
                ),
                Obx(
                  () => Container(
                    width: _toprightwidth,
                    child: Text(
                      S.current.song +
                          ": " +
                          controller.album.songCount.toString(),
                      style: nomalText,
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    width: _toprightwidth,
                    child: Text(
                      S.current.playCount +
                          ": " +
                          controller.album.playCount.toString(),
                      style: nomalText,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
            title: '全部播放',
            onTap: () => controller.handlePlay(),
          )),
          SizedBox(width: 10),
          Expanded(
            child: MButton(
              icon: Icons.shuffle,
              title: '随机播放',
              type: ButtonType.secondary,
              onTap: () => controller.handlePlay(true),
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
              () => MyTextButton(
                press: () {
                  activeID.value = controller.album.artistId;
                  indexValue.value = 9;
                },
                title: controller.album.artist,
              ),
            ),
          ),
          // 收藏按钮
          Container(
            height: 20,
            width: 25,
            child: MStarToogle(
              value: controller.staralbum.value,
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
              activeID.value = _title[i];
              indexValue.value = 4;
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
              return ListTile(
                title: InkWell(
                  onTap: () => controller.handleSongClick(_song, index),
                  child: ValueListenableBuilder<Map>(
                    valueListenable: activeSong,
                    builder: ((context, value, child) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _songlistView(
                          _title,
                          value.isNotEmpty && value["value"] == _song.id,
                          index,
                        ),
                      );
                    }),
                  ),
                ),
              );
            },
          )),
    );
  }

  List<Widget> _songlistView(
    List<String> _title,
    bool active,
    int _index,
  ) {
    return _title.asMap().keys.map((i) {
      if (i == 0) {
        return Expanded(
          flex: 1,
          child: Text(
            _title[i],
            textDirection: (i == 0) ? TextDirection.ltr : TextDirection.rtl,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: active
                  ? ThemeService.color.textPrimaryColor
                  : ThemeService.color.textColor,
            ),
          ),
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
