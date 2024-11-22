import 'package:get/get.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/services/audio_player_service.dart';

class PlayController extends GetxController {
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();

  final player = AudioPlayerService.player;

  List<String> get tabs => [S.current.song, S.current.lyric];

  get positionDataStream => audioPlayerService.positionDataStream;
}
