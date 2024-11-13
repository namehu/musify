import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/language_service.dart';
import 'package:musify/services/preferences_service.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:musify/util/mycss.dart';
import 'generated/l10n.dart';
import 'util/audioTools.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(800, 600),
      backgroundColor: Colors.black,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    isMobile = false;
  } else {
    isMobile = true;
    //Enable background playback on the mobile terminal
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.namehu.musify.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
  }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  //Register Get Services
  await Get.putAsync(() => PreferencesService().init());
  await Get.putAsync(() => ThemeService().init());
  await Get.putAsync(() => AudioPlayerService().init());
  await Get.putAsync(() => ServerService().init());
  await Get.putAsync(() => LanguageService().init());

  final AudioPlayer _player = AudioPlayerService.player;
  //监听器
  //register listener
  audioCurrentIndexStream(_player);
  audioActiveSongListener(_player);

  // PreferencesService.instance.getString('')
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        //useInheritedMediaQuery: true,
        title: "Musify",
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeService.theme,
        // theme: themeLight,
        // darkTheme: themeDark,
        // themeMode: ThemeService.mode.value,
        // home: MainScreen(),
        getPages: AppPages.pages,
        initialRoute: Routes.HOME,
      ),
    );
  }
}
