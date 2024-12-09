import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/constant.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/play_list.dart';
import 'package:musify/services/play_list_service.dart';
import 'package:musify/widgets/dialogs/play_list_dialog.dart';

class PlayListController extends GetxController {
  PlayListService playListService = Get.find<PlayListService>();

  final inputController = TextEditingController();

  RxList<Playlist> get playlistsList => playListService.playList;

  int get playlistnum => playlistsList.length;

  @override
  onInit() {
    super.onInit();
    _getPlaylist();
  }

  _getPlaylist() async {
    playListService.getPlayList();
  }

  addPlayList() async {
    var res = await showPlayListDialog();
    logger.i(res);
  }

  handleSwipeDelPlayList(String id) async {
    await playListService.deletePlayList(id);
  }

  handleSecondaryTapDel(
      BuildContext context, double x, double y, String text) async {
    var value = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(x, y, x, y),
      items: [
        PopupMenuItem(
          value: text,
          child: Text(S.current.delete + S.current.playlist),
        ),
      ],
    );

    if (value != null) {
      handleSwipeDelPlayList(text);
    }
  }
}
