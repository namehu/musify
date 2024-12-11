part of '../database.dart';

class PreferencesTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get downloadLocation => text().withDefault(const Constant(""))();

  TextColumn get audioQuality => textEnum<SourceQualities>()
      .withDefault(Constant(SourceQualities.high.name))();

  BoolColumn get systemTitleBar =>
      boolean().withDefault(const Constant(false))();

  BoolColumn get checkUpdate => boolean().withDefault(const Constant(true))();

  TextColumn get closeBehavior => textEnum<CloseBehavior>()
      .withDefault(Constant(CloseBehavior.close.name))();

  // Default values as PreferencesTableData
  static PreferencesTableData defaults() {
    return PreferencesTableData(
      id: 0,
      checkUpdate: true,
      closeBehavior: CloseBehavior.close,
      audioQuality: SourceQualities.high,
      systemTitleBar: false,
      downloadLocation: "",
    );
  }
}
