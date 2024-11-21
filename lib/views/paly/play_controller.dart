import 'package:get/get.dart';
import 'package:musify/services/audio_player_service.dart';

class PlayController extends GetxController {
  final AudioPlayerService audioPlayerService = Get.find<AudioPlayerService>();

  final player = AudioPlayerService.player;

  get positionDataStream => audioPlayerService.positionDataStream;
}
