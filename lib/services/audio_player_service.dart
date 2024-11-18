import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:musify/constant.dart';
import 'package:musify/models/notifierValue.dart';
import 'package:musify/models/songs.dart';

class HideMusicBarEvent {
  HideMusicBarEvent();
}

late EventBus hideMusicEventBus;

/**
 * 播放器服务
 * 提供全局的播放器实例
 */
class AudioPlayerService extends GetxService {
  static late AudioPlayer player;

  Rx<Songs> currentSong = Songs.fromInitial().obs;
  Rx<String> lyric = ''.obs;

  get lyricModel =>
      LyricsModelBuilder.create().bindLyricToMain(lyric.value).getModel();

  Future<AudioPlayerService> init() async {
    player = AudioPlayer();

    hideMusicEventBus = EventBus();
    hideMusicEventBus.on<HideMusicBarEvent>().listen((event) {
      hideMusicBar.value = false;
    });
    return this;
  }

  @override
  onClose() {
    hideMusicEventBus.destroy();
  }

  // 显示播放列表
  static showPlayList() async {
    var context = navigatorKey.currentState!.context;
    hideMusicBar.value = true;

    await showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (BuildContext _contenxt) => MPlayListModal());
  }
}

class MPlayListModal extends StatefulWidget {
  const MPlayListModal({super.key});

  @override
  State<MPlayListModal> createState() => _MPlayListModalState();
}

class _MPlayListModalState extends State<MPlayListModal> {
  @override
  void deactivate() {
    hideMusicEventBus.fire(HideMusicBarEvent());
    super.deactivate();
  }

  @override
  Widget build(BuildContext _context) {
    return Container(
      height: 200,
      color: Colors.amber,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Modal BottomSheet'),
            ElevatedButton(
              child: const Text('Close BottomSheet'),
              onPressed: () {
                hideMusicEventBus.fire(HideMusicBarEvent());
                var context = navigatorKey.currentState?.context;
                if (context != null) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
