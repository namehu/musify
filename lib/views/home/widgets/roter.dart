import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../screens/layout/artistAlbumScreen.dart';
import '../../../screens/layout/searchLyricScreen.dart';
import '../../../screens/layout/searchScreen.dart';
import 'indexScreen.dart';

class Roter extends StatelessWidget {
  final int roter;
  final AudioPlayer player;
  const Roter({
    Key? key,
    required this.roter,
    required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        switch (roter) {
          case 0: //首页
            return IndexScreen();
          case 2: //播放列表
          case 3: //收藏
          case 4: //专辑
          case 5: //歌手
          case 6: //流派
          case 7: //搜索歌词
            return SearchLyricScreen();
          case 9: //艺人详情
          case 10: //搜索
            return SearchScreen(player: player);
          case 12: //播放列表详细
          case 13: //艺人专辑
            return ArtistAlbumScreen();

          default:
            return IndexScreen();
        }
      },
    );
  }
}
