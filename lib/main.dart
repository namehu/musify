import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:logger/logger.dart';
import 'package:musify/constant.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/layout/bottom_desktop.dart';
import 'package:musify/layout/left_drawer.dart';
import 'package:musify/services/audio_player_service.dart';
import 'package:musify/services/language_service.dart';
import 'package:musify/services/music_bar_service.dart';
import 'package:musify/services/preferences_service.dart';
import 'package:musify/services/server_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:musify/util/mycss.dart';
import 'generated/l10n.dart';
import 'services/global_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
    ), // Use the PrettyPrinter to format and print log
  );

  if (Platform.isWindows) {
    sqfliteFfiInit();
  }

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

    // windowManager.addListener(MWindowListener());

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
  await Get.putAsync(() => GloabalService().init());
  await Get.putAsync(() => PreferencesService().init(sharedPreferences));
  await Get.putAsync(() => LanguageService().init());
  await Get.putAsync(() => ThemeService().init());
  await Get.putAsync(() => MusicBarService().init());
  await Get.putAsync(() => ServerService().init());
  await Get.putAsync(() => AudioPlayerService().init());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
