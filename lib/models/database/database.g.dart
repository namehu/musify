// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ServerTableTable extends ServerTable
    with TableInfo<$ServerTableTable, ServerTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServerTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverTypeMeta =
      const VerificationMeta('serverType');
  @override
  late final GeneratedColumn<String> serverType = GeneratedColumn<String>(
      'server_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseurlMeta =
      const VerificationMeta('baseurl');
  @override
  late final GeneratedColumn<String> baseurl = GeneratedColumn<String>(
      'baseurl', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<String> salt = GeneratedColumn<String>(
      'salt', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hashMeta = const VerificationMeta('hash');
  @override
  late final GeneratedColumn<String> hash = GeneratedColumn<String>(
      'hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ndCredentialMeta =
      const VerificationMeta('ndCredential');
  @override
  late final GeneratedColumn<String> ndCredential = GeneratedColumn<String>(
      'nd_credential', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverType,
        baseurl,
        userId,
        username,
        password,
        salt,
        hash,
        ndCredential
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'server_table';
  @override
  VerificationContext validateIntegrity(Insertable<ServerTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_type')) {
      context.handle(
          _serverTypeMeta,
          serverType.isAcceptableOrUnknown(
              data['server_type']!, _serverTypeMeta));
    } else if (isInserting) {
      context.missing(_serverTypeMeta);
    }
    if (data.containsKey('baseurl')) {
      context.handle(_baseurlMeta,
          baseurl.isAcceptableOrUnknown(data['baseurl']!, _baseurlMeta));
    } else if (isInserting) {
      context.missing(_baseurlMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('salt')) {
      context.handle(
          _saltMeta, salt.isAcceptableOrUnknown(data['salt']!, _saltMeta));
    } else if (isInserting) {
      context.missing(_saltMeta);
    }
    if (data.containsKey('hash')) {
      context.handle(
          _hashMeta, hash.isAcceptableOrUnknown(data['hash']!, _hashMeta));
    } else if (isInserting) {
      context.missing(_hashMeta);
    }
    if (data.containsKey('nd_credential')) {
      context.handle(
          _ndCredentialMeta,
          ndCredential.isAcceptableOrUnknown(
              data['nd_credential']!, _ndCredentialMeta));
    } else if (isInserting) {
      context.missing(_ndCredentialMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServerTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServerTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_type'])!,
      baseurl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}baseurl'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      salt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}salt'])!,
      hash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hash'])!,
      ndCredential: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nd_credential'])!,
    );
  }

  @override
  $ServerTableTable createAlias(String alias) {
    return $ServerTableTable(attachedDatabase, alias);
  }
}

class ServerTableData extends DataClass implements Insertable<ServerTableData> {
  final int id;
  final String serverType;
  final String baseurl;
  final String userId;
  final String username;
  final String password;
  final String salt;
  final String hash;
  final String ndCredential;
  const ServerTableData(
      {required this.id,
      required this.serverType,
      required this.baseurl,
      required this.userId,
      required this.username,
      required this.password,
      required this.salt,
      required this.hash,
      required this.ndCredential});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_type'] = Variable<String>(serverType);
    map['baseurl'] = Variable<String>(baseurl);
    map['user_id'] = Variable<String>(userId);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['salt'] = Variable<String>(salt);
    map['hash'] = Variable<String>(hash);
    map['nd_credential'] = Variable<String>(ndCredential);
    return map;
  }

  ServerTableCompanion toCompanion(bool nullToAbsent) {
    return ServerTableCompanion(
      id: Value(id),
      serverType: Value(serverType),
      baseurl: Value(baseurl),
      userId: Value(userId),
      username: Value(username),
      password: Value(password),
      salt: Value(salt),
      hash: Value(hash),
      ndCredential: Value(ndCredential),
    );
  }

  factory ServerTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerTableData(
      id: serializer.fromJson<int>(json['id']),
      serverType: serializer.fromJson<String>(json['serverType']),
      baseurl: serializer.fromJson<String>(json['baseurl']),
      userId: serializer.fromJson<String>(json['userId']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      salt: serializer.fromJson<String>(json['salt']),
      hash: serializer.fromJson<String>(json['hash']),
      ndCredential: serializer.fromJson<String>(json['ndCredential']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverType': serializer.toJson<String>(serverType),
      'baseurl': serializer.toJson<String>(baseurl),
      'userId': serializer.toJson<String>(userId),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'salt': serializer.toJson<String>(salt),
      'hash': serializer.toJson<String>(hash),
      'ndCredential': serializer.toJson<String>(ndCredential),
    };
  }

  ServerTableData copyWith(
          {int? id,
          String? serverType,
          String? baseurl,
          String? userId,
          String? username,
          String? password,
          String? salt,
          String? hash,
          String? ndCredential}) =>
      ServerTableData(
        id: id ?? this.id,
        serverType: serverType ?? this.serverType,
        baseurl: baseurl ?? this.baseurl,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        password: password ?? this.password,
        salt: salt ?? this.salt,
        hash: hash ?? this.hash,
        ndCredential: ndCredential ?? this.ndCredential,
      );
  ServerTableData copyWithCompanion(ServerTableCompanion data) {
    return ServerTableData(
      id: data.id.present ? data.id.value : this.id,
      serverType:
          data.serverType.present ? data.serverType.value : this.serverType,
      baseurl: data.baseurl.present ? data.baseurl.value : this.baseurl,
      userId: data.userId.present ? data.userId.value : this.userId,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      salt: data.salt.present ? data.salt.value : this.salt,
      hash: data.hash.present ? data.hash.value : this.hash,
      ndCredential: data.ndCredential.present
          ? data.ndCredential.value
          : this.ndCredential,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServerTableData(')
          ..write('id: $id, ')
          ..write('serverType: $serverType, ')
          ..write('baseurl: $baseurl, ')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('salt: $salt, ')
          ..write('hash: $hash, ')
          ..write('ndCredential: $ndCredential')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serverType, baseurl, userId, username,
      password, salt, hash, ndCredential);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerTableData &&
          other.id == this.id &&
          other.serverType == this.serverType &&
          other.baseurl == this.baseurl &&
          other.userId == this.userId &&
          other.username == this.username &&
          other.password == this.password &&
          other.salt == this.salt &&
          other.hash == this.hash &&
          other.ndCredential == this.ndCredential);
}

class ServerTableCompanion extends UpdateCompanion<ServerTableData> {
  final Value<int> id;
  final Value<String> serverType;
  final Value<String> baseurl;
  final Value<String> userId;
  final Value<String> username;
  final Value<String> password;
  final Value<String> salt;
  final Value<String> hash;
  final Value<String> ndCredential;
  const ServerTableCompanion({
    this.id = const Value.absent(),
    this.serverType = const Value.absent(),
    this.baseurl = const Value.absent(),
    this.userId = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.salt = const Value.absent(),
    this.hash = const Value.absent(),
    this.ndCredential = const Value.absent(),
  });
  ServerTableCompanion.insert({
    this.id = const Value.absent(),
    required String serverType,
    required String baseurl,
    required String userId,
    required String username,
    required String password,
    required String salt,
    required String hash,
    required String ndCredential,
  })  : serverType = Value(serverType),
        baseurl = Value(baseurl),
        userId = Value(userId),
        username = Value(username),
        password = Value(password),
        salt = Value(salt),
        hash = Value(hash),
        ndCredential = Value(ndCredential);
  static Insertable<ServerTableData> custom({
    Expression<int>? id,
    Expression<String>? serverType,
    Expression<String>? baseurl,
    Expression<String>? userId,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? salt,
    Expression<String>? hash,
    Expression<String>? ndCredential,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverType != null) 'server_type': serverType,
      if (baseurl != null) 'baseurl': baseurl,
      if (userId != null) 'user_id': userId,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (salt != null) 'salt': salt,
      if (hash != null) 'hash': hash,
      if (ndCredential != null) 'nd_credential': ndCredential,
    });
  }

  ServerTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? serverType,
      Value<String>? baseurl,
      Value<String>? userId,
      Value<String>? username,
      Value<String>? password,
      Value<String>? salt,
      Value<String>? hash,
      Value<String>? ndCredential}) {
    return ServerTableCompanion(
      id: id ?? this.id,
      serverType: serverType ?? this.serverType,
      baseurl: baseurl ?? this.baseurl,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      password: password ?? this.password,
      salt: salt ?? this.salt,
      hash: hash ?? this.hash,
      ndCredential: ndCredential ?? this.ndCredential,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverType.present) {
      map['server_type'] = Variable<String>(serverType.value);
    }
    if (baseurl.present) {
      map['baseurl'] = Variable<String>(baseurl.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (salt.present) {
      map['salt'] = Variable<String>(salt.value);
    }
    if (hash.present) {
      map['hash'] = Variable<String>(hash.value);
    }
    if (ndCredential.present) {
      map['nd_credential'] = Variable<String>(ndCredential.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerTableCompanion(')
          ..write('id: $id, ')
          ..write('serverType: $serverType, ')
          ..write('baseurl: $baseurl, ')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('salt: $salt, ')
          ..write('hash: $hash, ')
          ..write('ndCredential: $ndCredential')
          ..write(')'))
        .toString();
  }
}

class $LyricsTableTable extends LyricsTable
    with TableInfo<$LyricsTableTable, LyricsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LyricsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _lyricMeta = const VerificationMeta('lyric');
  @override
  late final GeneratedColumn<String> lyric = GeneratedColumn<String>(
      'lyric', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<String> songId = GeneratedColumn<String>(
      'song_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, lyric, songId, serverId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lyrics_table';
  @override
  VerificationContext validateIntegrity(Insertable<LyricsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lyric')) {
      context.handle(
          _lyricMeta, lyric.isAcceptableOrUnknown(data['lyric']!, _lyricMeta));
    } else if (isInserting) {
      context.missing(_lyricMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(_songIdMeta,
          songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta));
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LyricsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LyricsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lyric: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lyric'])!,
      songId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}song_id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id'])!,
    );
  }

  @override
  $LyricsTableTable createAlias(String alias) {
    return $LyricsTableTable(attachedDatabase, alias);
  }
}

class LyricsTableData extends DataClass implements Insertable<LyricsTableData> {
  final int id;
  final String lyric;
  final String songId;
  final int serverId;
  const LyricsTableData(
      {required this.id,
      required this.lyric,
      required this.songId,
      required this.serverId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lyric'] = Variable<String>(lyric);
    map['song_id'] = Variable<String>(songId);
    map['server_id'] = Variable<int>(serverId);
    return map;
  }

  LyricsTableCompanion toCompanion(bool nullToAbsent) {
    return LyricsTableCompanion(
      id: Value(id),
      lyric: Value(lyric),
      songId: Value(songId),
      serverId: Value(serverId),
    );
  }

  factory LyricsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LyricsTableData(
      id: serializer.fromJson<int>(json['id']),
      lyric: serializer.fromJson<String>(json['lyric']),
      songId: serializer.fromJson<String>(json['songId']),
      serverId: serializer.fromJson<int>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lyric': serializer.toJson<String>(lyric),
      'songId': serializer.toJson<String>(songId),
      'serverId': serializer.toJson<int>(serverId),
    };
  }

  LyricsTableData copyWith(
          {int? id, String? lyric, String? songId, int? serverId}) =>
      LyricsTableData(
        id: id ?? this.id,
        lyric: lyric ?? this.lyric,
        songId: songId ?? this.songId,
        serverId: serverId ?? this.serverId,
      );
  LyricsTableData copyWithCompanion(LyricsTableCompanion data) {
    return LyricsTableData(
      id: data.id.present ? data.id.value : this.id,
      lyric: data.lyric.present ? data.lyric.value : this.lyric,
      songId: data.songId.present ? data.songId.value : this.songId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LyricsTableData(')
          ..write('id: $id, ')
          ..write('lyric: $lyric, ')
          ..write('songId: $songId, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lyric, songId, serverId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LyricsTableData &&
          other.id == this.id &&
          other.lyric == this.lyric &&
          other.songId == this.songId &&
          other.serverId == this.serverId);
}

class LyricsTableCompanion extends UpdateCompanion<LyricsTableData> {
  final Value<int> id;
  final Value<String> lyric;
  final Value<String> songId;
  final Value<int> serverId;
  const LyricsTableCompanion({
    this.id = const Value.absent(),
    this.lyric = const Value.absent(),
    this.songId = const Value.absent(),
    this.serverId = const Value.absent(),
  });
  LyricsTableCompanion.insert({
    this.id = const Value.absent(),
    required String lyric,
    required String songId,
    required int serverId,
  })  : lyric = Value(lyric),
        songId = Value(songId),
        serverId = Value(serverId);
  static Insertable<LyricsTableData> custom({
    Expression<int>? id,
    Expression<String>? lyric,
    Expression<String>? songId,
    Expression<int>? serverId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lyric != null) 'lyric': lyric,
      if (songId != null) 'song_id': songId,
      if (serverId != null) 'server_id': serverId,
    });
  }

  LyricsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? lyric,
      Value<String>? songId,
      Value<int>? serverId}) {
    return LyricsTableCompanion(
      id: id ?? this.id,
      lyric: lyric ?? this.lyric,
      songId: songId ?? this.songId,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lyric.present) {
      map['lyric'] = Variable<String>(lyric.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<String>(songId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LyricsTableCompanion(')
          ..write('id: $id, ')
          ..write('lyric: $lyric, ')
          ..write('songId: $songId, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ServerTableTable serverTable = $ServerTableTable(this);
  late final $LyricsTableTable lyricsTable = $LyricsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [serverTable, lyricsTable];
}

typedef $$ServerTableTableCreateCompanionBuilder = ServerTableCompanion
    Function({
  Value<int> id,
  required String serverType,
  required String baseurl,
  required String userId,
  required String username,
  required String password,
  required String salt,
  required String hash,
  required String ndCredential,
});
typedef $$ServerTableTableUpdateCompanionBuilder = ServerTableCompanion
    Function({
  Value<int> id,
  Value<String> serverType,
  Value<String> baseurl,
  Value<String> userId,
  Value<String> username,
  Value<String> password,
  Value<String> salt,
  Value<String> hash,
  Value<String> ndCredential,
});

class $$ServerTableTableFilterComposer
    extends Composer<_$AppDatabase, $ServerTableTable> {
  $$ServerTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverType => $composableBuilder(
      column: $table.serverType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseurl => $composableBuilder(
      column: $table.baseurl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hash => $composableBuilder(
      column: $table.hash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ndCredential => $composableBuilder(
      column: $table.ndCredential, builder: (column) => ColumnFilters(column));
}

class $$ServerTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ServerTableTable> {
  $$ServerTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverType => $composableBuilder(
      column: $table.serverType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseurl => $composableBuilder(
      column: $table.baseurl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get salt => $composableBuilder(
      column: $table.salt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hash => $composableBuilder(
      column: $table.hash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ndCredential => $composableBuilder(
      column: $table.ndCredential,
      builder: (column) => ColumnOrderings(column));
}

class $$ServerTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServerTableTable> {
  $$ServerTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverType => $composableBuilder(
      column: $table.serverType, builder: (column) => column);

  GeneratedColumn<String> get baseurl =>
      $composableBuilder(column: $table.baseurl, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<String> get hash =>
      $composableBuilder(column: $table.hash, builder: (column) => column);

  GeneratedColumn<String> get ndCredential => $composableBuilder(
      column: $table.ndCredential, builder: (column) => column);
}

class $$ServerTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ServerTableTable,
    ServerTableData,
    $$ServerTableTableFilterComposer,
    $$ServerTableTableOrderingComposer,
    $$ServerTableTableAnnotationComposer,
    $$ServerTableTableCreateCompanionBuilder,
    $$ServerTableTableUpdateCompanionBuilder,
    (
      ServerTableData,
      BaseReferences<_$AppDatabase, $ServerTableTable, ServerTableData>
    ),
    ServerTableData,
    PrefetchHooks Function()> {
  $$ServerTableTableTableManager(_$AppDatabase db, $ServerTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServerTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServerTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServerTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> serverType = const Value.absent(),
            Value<String> baseurl = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String> salt = const Value.absent(),
            Value<String> hash = const Value.absent(),
            Value<String> ndCredential = const Value.absent(),
          }) =>
              ServerTableCompanion(
            id: id,
            serverType: serverType,
            baseurl: baseurl,
            userId: userId,
            username: username,
            password: password,
            salt: salt,
            hash: hash,
            ndCredential: ndCredential,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String serverType,
            required String baseurl,
            required String userId,
            required String username,
            required String password,
            required String salt,
            required String hash,
            required String ndCredential,
          }) =>
              ServerTableCompanion.insert(
            id: id,
            serverType: serverType,
            baseurl: baseurl,
            userId: userId,
            username: username,
            password: password,
            salt: salt,
            hash: hash,
            ndCredential: ndCredential,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ServerTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ServerTableTable,
    ServerTableData,
    $$ServerTableTableFilterComposer,
    $$ServerTableTableOrderingComposer,
    $$ServerTableTableAnnotationComposer,
    $$ServerTableTableCreateCompanionBuilder,
    $$ServerTableTableUpdateCompanionBuilder,
    (
      ServerTableData,
      BaseReferences<_$AppDatabase, $ServerTableTable, ServerTableData>
    ),
    ServerTableData,
    PrefetchHooks Function()>;
typedef $$LyricsTableTableCreateCompanionBuilder = LyricsTableCompanion
    Function({
  Value<int> id,
  required String lyric,
  required String songId,
  required int serverId,
});
typedef $$LyricsTableTableUpdateCompanionBuilder = LyricsTableCompanion
    Function({
  Value<int> id,
  Value<String> lyric,
  Value<String> songId,
  Value<int> serverId,
});

class $$LyricsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lyric => $composableBuilder(
      column: $table.lyric, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get songId => $composableBuilder(
      column: $table.songId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));
}

class $$LyricsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lyric => $composableBuilder(
      column: $table.lyric, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get songId => $composableBuilder(
      column: $table.songId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));
}

class $$LyricsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LyricsTableTable> {
  $$LyricsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lyric =>
      $composableBuilder(column: $table.lyric, builder: (column) => column);

  GeneratedColumn<String> get songId =>
      $composableBuilder(column: $table.songId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);
}

class $$LyricsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LyricsTableTable,
    LyricsTableData,
    $$LyricsTableTableFilterComposer,
    $$LyricsTableTableOrderingComposer,
    $$LyricsTableTableAnnotationComposer,
    $$LyricsTableTableCreateCompanionBuilder,
    $$LyricsTableTableUpdateCompanionBuilder,
    (
      LyricsTableData,
      BaseReferences<_$AppDatabase, $LyricsTableTable, LyricsTableData>
    ),
    LyricsTableData,
    PrefetchHooks Function()> {
  $$LyricsTableTableTableManager(_$AppDatabase db, $LyricsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LyricsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LyricsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LyricsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> lyric = const Value.absent(),
            Value<String> songId = const Value.absent(),
            Value<int> serverId = const Value.absent(),
          }) =>
              LyricsTableCompanion(
            id: id,
            lyric: lyric,
            songId: songId,
            serverId: serverId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String lyric,
            required String songId,
            required int serverId,
          }) =>
              LyricsTableCompanion.insert(
            id: id,
            lyric: lyric,
            songId: songId,
            serverId: serverId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LyricsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LyricsTableTable,
    LyricsTableData,
    $$LyricsTableTableFilterComposer,
    $$LyricsTableTableOrderingComposer,
    $$LyricsTableTableAnnotationComposer,
    $$LyricsTableTableCreateCompanionBuilder,
    $$LyricsTableTableUpdateCompanionBuilder,
    (
      LyricsTableData,
      BaseReferences<_$AppDatabase, $LyricsTableTable, LyricsTableData>
    ),
    LyricsTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ServerTableTableTableManager get serverTable =>
      $$ServerTableTableTableManager(_db, _db.serverTable);
  $$LyricsTableTableTableManager get lyricsTable =>
      $$LyricsTableTableTableManager(_db, _db.lyricsTable);
}
