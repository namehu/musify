import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:musify/constant.dart';
import 'package:musify/hooks/configurators/use_close_behavior.dart';
import 'package:musify/hooks/configurators/use_fix_window_stretching.dart';
import 'package:musify/models/database/database.dart';
import 'package:musify/provider/database/database.dart';
import 'package:musify/provider/tray_manager/tray_manager.dart';
import 'package:musify/provider/user_preferences/user_preferences_provider.dart';
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
import 'package:musify/styles/theme.dart';
import 'package:musify/util/cli.dart';
import 'package:musify/util/logger.dart';
import 'package:musify/util/platform.dart';
import 'package:musify/util/wins/wm_tools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:musify/util/mycss.dart';
import 'generated/l10n.dart';
import 'services/global_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'util/initializers.dart';

void main(List<String> rawArgs) async {
  //   if (rawArgs.contains("web_view_title_bar")) {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   if (runWebViewTitleBarWidget(rawArgs)) {
  //     return;
  //   }
  // }

  final arguments = await startCLI(rawArgs);
  AppLogger.initialize(arguments["verbose"]);

  AppLogger.runZoned(() async {
    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    await registerWindowsScheme("Musify");

    // Necessary initialization for package:media_kit.
    MediaKit.ensureInitialized();

    // force High Refresh Rate on some Android devices (like One Plus)
    if (kIsAndroid) {
      await FlutterDisplayMode.setHighRefreshRate();
    }

    if (kIsDesktop) {
      await windowManager.setPreventClose(true);
    }

    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
    }
    sharedPreferences = await SharedPreferences.getInstance();

    logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
      ), // Use the PrettyPrinter to format and print log
    );

    database = AppDatabase();

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
      isMobile = false;
    } else {
      isMobile = true;
      //Enable background playback on the mobile terminal
      // await JustAudioBackground.init(
      //   androidNotificationChannelId: 'com.namehu.musify.audio',
      //   androidNotificationChannelName: 'Audio playback',
      //   androidNotificationOngoing: true,
      // );
    }

    if (kIsDesktop) {
      await localNotifier.setup(appName: "Musify");
      await WindowManagerTools.initialize();
    }

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    runApp(ProviderScope(
      overrides: [
        databaseProvider.overrideWith((ref) => database),
      ],
      // For widgets to be able to read providers, we need to wrap the entire
      // application in a "ProviderScope" widget.
      // This is where the state of our providers will be stored.
      child: MyApp(),
    ));
  });
}

class MyApp extends HookConsumerWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final themeMode =
        ref.watch(userPreferencesProvider.select((s) => s.themeMode));
    final accentMaterialColor =
        ref.watch(userPreferencesProvider.select((s) => s.accentColorScheme));
    final locale = ref.watch(userPreferencesProvider.select((s) => s.locale));

    final lightTheme = useMemoized(
      () => theme(accentMaterialColor, Brightness.light, false),
      [accentMaterialColor],
    );
    final darkTheme = useMemoized(
      () => theme(
        accentMaterialColor,
        Brightness.dark,
        false,
      ),
      [accentMaterialColor],
    );

    ref.listen(trayManagerProvider, (_, __) {});

    useFixWindowStretching();
    useCloseBehavior(ref);

    return MaterialApp(
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      home: GetMaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        //useInheritedMediaQuery: true,
        title: APP_NAME,
        locale: locale.languageCode == "system" ? null : locale,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        // theme: ThemeService.theme,
        themeMode: themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
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
    );
  }
}
