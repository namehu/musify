import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:musify/enums/serve_type_enum.dart';
import 'package:musify/util/platform.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

part 'tables/lyrics.dart';
part 'tables/server.dart';
part 'database.g.dart';

// class TodoItems extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text().withLength(min: 6, max: 32)();
//   TextColumn get content => text().named('body')();
//   IntColumn get category =>
//       integer().nullable().references(TodoCategory, #id)();
//   DateTimeColumn get createdAt => dateTime().nullable()();
// }

// class TodoCategory extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get description => text()();
// }

@DriftDatabase(tables: [
  // TodoItems,
  // TodoCategory,
  ServerTable,
  LyricsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // @override
  // MigrationStrategy get migration {
  //   return MigrationStrategy(
  //     onUpgrade: stepByStep(
  //       from1To2: (m, schema) async {
  //         // Add invidiousInstance column to preferences table
  //         await m.addColumn(
  //           schema.preferencesTable,
  //           schema.preferencesTable.invidiousInstance,
  //         );
  //       },
  //       from2To3: (m, schema) async {
  //         await m.addColumn(
  //           schema.preferencesTable,
  //           schema.preferencesTable.cacheMusic,
  //         );
  //       },
  //     ),
  //   );
  // }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(join(dbFolder.path, 'musify.sqlite'));

    // Also work around limitations on old Android versions
    if (kIsAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    // Make sqlite3 pick a more suitable location for temporary files - the
    // one from the system may be inaccessible due to sandboxing.
    final cacheBase = (await getTemporaryDirectory()).path;
    // We can't access /tmp on Android, which sqlite3 would try by default.
    // Explicitly tell it about the correct temporary directory.
    sqlite3.tempDirectory = cacheBase;

    return NativeDatabase.createInBackground(file);
  });
}
