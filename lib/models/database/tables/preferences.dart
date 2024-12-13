part of '../database.dart';

class PreferencesTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get downloadLocation => text().withDefault(const Constant(""))();

  TextColumn get audioQuality => textEnum<SourceQualities>()
      .withDefault(Constant(SourceQualities.high.name))();

  BoolColumn get showSystemTrayIcon =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get systemTitleBar =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get checkUpdate => boolean().withDefault(const Constant(true))();

  TextColumn get closeBehavior => textEnum<CloseBehavior>()
      .withDefault(Constant(CloseBehavior.close.name))();

  TextColumn get themeMode =>
      textEnum<ThemeMode>().withDefault(Constant(ThemeMode.system.name))();

  TextColumn get accentColorScheme => text()
      .withDefault(const Constant("Blue:0xFF2196F3"))
      .map(const SpotubeColorConverter())();

  TextColumn get locale => text()
      .withDefault(
        const Constant(
            '{"languageCode":"system","countryCode":"system", scriptCode: ""}'),
      )
      .map(const LocaleConverter())();

  // Default values as PreferencesTableData
  static PreferencesTableData defaults() {
    return PreferencesTableData(
      id: 0,
      downloadLocation: "",
      audioQuality: SourceQualities.high,
      showSystemTrayIcon: true,
      systemTitleBar: false,
      checkUpdate: true,
      closeBehavior: CloseBehavior.close,
      themeMode: ThemeMode.system,
      accentColorScheme: SpotubeColor(Colors.blue.value, name: "Blue"),
      locale: const Locale.fromSubtags(
          languageCode: "system", countryCode: "system", scriptCode: 'system'),
    );
  }
}
