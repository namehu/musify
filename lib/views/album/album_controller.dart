import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musify/api/index.dart';
import 'package:musify/enums/play_mode_enum.dart';
import 'package:musify/enums/star_type_enum.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/models/myModel.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/star_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/colors.dart';
import 'package:musify/widgets/m_toast.dart';
import 'package:palette_generator/palette_generator.dart';
import '../../models/songs.dart';

class AlbumController extends GetxController {
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();
  final StarService starService = Get.find<StarService>();

  final _album = (Albums.fromJson({})).obs;

  final ScrollController scrollController = ScrollController();

  Rx<PaletteGenerator> paletteGenerator = PaletteGenerator.fromColors([]).obs;

  RxBool showTitle = false.obs;

  final RxBool staralbum = false.obs; // 是否收藏专辑

  final double headHeight = GetPlatform.isMobile ? 200 : 300;

  Albums get album => _album.value;

  List<Songs> get songs => _album.value.song;

  Color? get imageMainColor =>
      paletteGenerator.value.dominantColor?.color ?? ThemeService.color.bgColor;

  Color? get textColor {
    if (imageMainColor != null) {
      return imageMainColor!.computeLuminance() > 0.5
          ? ThemeService.color.textColor
          : gray1;
    }

    return ThemeService.color.textColor;
  }

  @override
  void onInit() {
    super.onInit();

    var id = Get.arguments?['id'];
    if (id != null) {
      _getAlbum(id).then((_) {
        _updatePaletteGenerator();
      });
    }

    scrollController.addListener(() {
      showTitle(scrollController.offset > headHeight - 50);
    });
  }

  @override
  void onClose() {
    super.onClose();

    scrollController.dispose();
  }

  Future<void> _getAlbum(String albumId) async {
    Albums? albumsData = await MRequest.api.getAlbum(albumId);
    if (albumsData != null) {
      _album(albumsData);
    }
  }

  Future<void> _updatePaletteGenerator() async {
    var imageSize = Size(256.0, 170.0);
    var region = Offset.zero & Size(256.0, 170.0);
    paletteGenerator.value = await PaletteGenerator.fromImageProvider(
      NetworkImage(album.coverUrl),
      size: imageSize,
      region: region,
      maximumColorCount: 20,
    );
  }

  /// 处理播放
  handlePlay([PlayModeEnum? mode = PlayModeEnum.loop]) {
    if (songs.isEmpty) {
      MToast.show(S.current.noSong);
      return;
    }

    audioPlayerService.tooglePlayMode(mode, false);
    int index = 0;
    Songs song = songs[0];

    handleSongClick(song, index);
  }

  handleStarToggle(bool val) async {
    await starService.toggleStar(
      id: album.id,
      type: StarTypeEnum.album,
      star: val,
    );

    _album.update((va) {
      va!.starred = !va.starred;
    });
  }

  /// 点击歌曲播放
  handleSongClick(Songs songData, int index) {
    audioPlayerService.palySongList(songs, index: index);
  }

  playSong([int? index = 0]) {
    var songs = album.song;
    audioPlayerService.palySongList(songs, index: index);
  }
}
