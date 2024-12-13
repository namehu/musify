import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:musify/models/database/database.dart';
import 'package:musify/modules/settings/color_scheme_picker_dialog.dart';
import 'package:musify/util/logger.dart';
import 'package:musify/util/platform.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path_provider/path_provider.dart' as paths;
import 'package:window_manager/window_manager.dart';

import '../database/database.dart';

part 'user_preferences_provider.g.dart';

// This will generates a Notifier and NotifierProvider.
// The Notifier class that will be passed to our NotifierProvider.
// This class should not expose state outside of its "state" property, which means
// no public getters/properties!
// The public methods on this class will be what allow the UI to modify the state.
// Finally, we are using todosProvider(NotifierProvider) to allow the UI to
// interact with our Todos class.
@riverpod
class UserPreferences extends _$UserPreferences {
  @override
  PreferencesTableData build() {
    final db = ref.watch(databaseProvider);

    (db.select(db.preferencesTable)..where((tbl) => tbl.id.equals(0)))
        .getSingleOrNull()
        .then((result) async {
      if (result == null) {
        await db.into(db.preferencesTable).insert(
              PreferencesTableCompanion.insert(
                id: const Value(0),
                downloadLocation: Value(await _getDefaultDownloadDirectory()),
              ),
            );
      }

      final query =
          (db.select(db.preferencesTable)..where((tbl) => tbl.id.equals(0)));

      state = await query.getSingle();

      final subscription = (db.select(db.preferencesTable)
            ..where((tbl) => tbl.id.equals(0)))
          .watchSingle()
          .listen((event) async {
        try {
          state = event;

          if (kIsDesktop) {
            await windowManager.setTitleBarStyle(
              state.systemTitleBar
                  ? TitleBarStyle.normal
                  : TitleBarStyle.hidden,
            );
          }

          // await audioPlayer.setAudioNormalization(state.normalizeAudio);
        } catch (e, stack) {
          AppLogger.reportError(e, stack);
        }
      });

      ref.onDispose(() {
        subscription.cancel();
      });
    });

    return PreferencesTable.defaults();
  }

  Future<void> setData(PreferencesTableCompanion data) async {
    final db = ref.read(databaseProvider);

    final query = db.update(db.preferencesTable)..where((t) => t.id.equals(0));

    await query.write(data);
  }

  Future<void> reset() async {
    final db = ref.read(databaseProvider);

    final query = db.update(db.preferencesTable)..where((t) => t.id.equals(0));

    await query.replace(PreferencesTableCompanion.insert());
  }

  static Future<String> getMusicCacheDir() async {
    if (kIsAndroid) {
      final dir =
          await paths.getExternalCacheDirectories().then((dirs) => dirs!.first);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return join(dir.path, 'Cached Tracks');
    }

    final dir = await paths.getApplicationCacheDirectory();
    return join(dir.path, 'cached_tracks');
  }

  Future<void> openCacheFolder() async {
    try {
      final filePath = await getMusicCacheDir();

      await OpenFile.open(filePath);
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
    }
  }

  void setThemeMode(ThemeMode mode) {
    setData(PreferencesTableCompanion(themeMode: Value(mode)));
  }

  void setCheckUpdate(bool check) {
    setData(PreferencesTableCompanion(checkUpdate: Value(check)));
  }

  void setAccentColorScheme(SpotubeColor color) {
    setData(PreferencesTableCompanion(accentColorScheme: Value(color)));
  }

  void setLocale(Locale locale) {
    setData(PreferencesTableCompanion(locale: Value(locale)));
  }

  Future<String> _getDefaultDownloadDirectory() async {
    if (kIsAndroid) return "/storage/emulated/0/Download/Spotube";

    if (kIsMacOS) {
      return join((await paths.getLibraryDirectory()).path, "Caches");
    }

    return paths.getDownloadsDirectory().then((dir) {
      return join(dir!.path, "Musify");
    });
  }
}
