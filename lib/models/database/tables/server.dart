part of '../database.dart';

class ServerTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get serverType => text()();

  TextColumn get baseurl => text()();

  TextColumn get userId => text()();
  TextColumn get username => text()();
  TextColumn get password => text()();
  TextColumn get salt => text()();
  TextColumn get hash => text()();
  TextColumn get ndCredential => text()();

  static ServerTableData defaults() {
    return ServerTableData(
      id: 0,
      serverType: ServeTypeEnum.navidrome.label,
      baseurl: '',
      userId: '',
      username: '',
      password: '',
      salt: '',
      hash: '',
      ndCredential: '',
    );
  }
}
