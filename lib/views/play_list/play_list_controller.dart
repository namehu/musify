import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/screens/common/myAlertDialog.dart';
import 'package:musify/util/audioTools.dart';
import 'package:musify/util/httpClient.dart';
import 'package:musify/widgets/m_toast.dart';

class PlayListController extends GetxController {
  var playlistsList = <Playlist>[].obs;
  final inputController = new TextEditingController();

  int get playlistnum => playlistsList.length;

  @override
  onInit() {
    super.onInit();
    _getPlaylist();
  }

  _getPlaylist() async {
    final _playlists = await getPlaylists();

    playlistsList.clear();

    if (_playlists != null && _playlists.length > 0) {
      for (var element in _playlists) {
        String _url = getCoverArt(element['id']);
        element["imageUrl"] = _url;
        Playlist _playlist = Playlist.fromJson(element);
        playlistsList.add(_playlist);
      }
    }
  }

  addPlayList() async {
    var context = Get.context!;
    await newPlaylistDialog(context).then((value) {
      _getPlaylist();
      switch (value) {
        case 1:
          showMyAlertDialog(
              context, S.current.notive, S.current.create + S.current.failure);
          break;
        case 2:
          showMyAlertDialog(context, S.current.notive,
              S.current.pleaseInput + S.current.playlist + S.current.name);
          break;
        case 3:
          break;
        default:
      }
    });
  }

  handleSwipeDelPlayList(String id) async {
    await deletePlaylist(id);
    _getPlaylist();
    MToast.show(S.current.delete + S.current.success);
  }

  handleSecondaryTapDel(
      BuildContext context, double _x, double _y, String text) async {
    var value = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(_x, _y, _x, _y),
      items: [
        PopupMenuItem(
          child: Text(S.current.delete + S.current.playlist),
          value: text,
        ),
      ],
    );

    if (value != null) {
      handleSwipeDelPlayList(text);
    }
  }
}
