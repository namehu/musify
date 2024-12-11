part of '../database.dart';

class LyricsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get lyric => text()();

  TextColumn get songId => text()();

  IntColumn get serverId => integer()();
}
