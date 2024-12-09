import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:musify/constant.dart';
import 'package:musify/routes/middlewares.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/layout/bottom_desktop.dart';
import 'package:musify/layout/left_drawer.dart';
import 'package:musify/services/album_service.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/language_service.dart';
import 'package:musify/services/music_bar_service.dart';
import 'package:musify/services/play_list_service.dart';
import 'package:musify/services/preferences_service.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/services/star_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:musify/util/mycss.dart';
import 'generated/l10n.dart';
import 'services/global_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'util/audio_player_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  sharedPreferences = await SharedPreferences.getInstance();

  logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
    ), // Use the PrettyPrinter to format and print log
  );

  //Register Get Services
  await Get.putAsync(() => GloabalService().init());
  await Get.putAsync(() => PreferencesService().init(sharedPreferences));
  await Get.putAsync(() => LanguageService().init());
  await Get.putAsync(() => ThemeService().init());
  await Get.putAsync(() => MusicBarService().init());
  await Get.putAsync(() => ServerService().init());
  await Get.putAsync(() => PlayListService().init());
  await Get.putAsync(() => AudioPlayerService().init());
  await Get.putAsync(() => AlbumServrice().init());
  await Get.putAsync(() => StarService().init());

  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(800, 600),
      backgroundColor: Colors.black,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    isMobile = false;
  } else {
    isMobile = true;
    //Enable background playback on the mobile terminal
    // await JustAudioBackground.init(
    //   androidNotificationChannelId: 'com.namehu.musify.audio',
    //   androidNotificationChannelName: 'Audio playback',
    //   androidNotificationOngoing: true,
    // );

    audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.namehu.musify.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
        androidResumeOnClick: true,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidShowNotificationBadge: false,
        androidNotificationClickStartsActivity: true,
        androidStopForegroundOnPause: true,
        fastForwardInterval: const Duration(seconds: 10),
        rewindInterval: const Duration(seconds: 10),
        preloadArtwork: false,
      ),
    );
  }

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return MaterialApp(
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      home: Obx(
        () => GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          //useInheritedMediaQuery: true,
          title: APP_NAME,
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeService.theme,
          getPages: AppPages.pages,
          initialRoute: Routes.HOME,
          transitionDuration: isMobile ? null : Duration(milliseconds: 0),
          routingCallback: (routing) {
            toggleMusicBar(routing);
            togglePCTabActive(routing);
          },

          builder: (context, child) {
            if (isMobile) {
              return child ?? Container();
            }

            return Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Obx(
                          () => GloabalService.hidePCLayout.value
                              ? Container()
                              : LeftDrawer(),
                        ),
                        Expanded(child: child ?? Container()),
                      ],
                    ),
                  ),
                  Obx(
                    () => GloabalService.hidePCLayout.value
                        ? Container()
                        : BottomDesktop(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
