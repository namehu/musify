// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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

class $PreferencesTableTable extends PreferencesTable
    with TableInfo<$PreferencesTableTable, PreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _downloadLocationMeta =
      const VerificationMeta('downloadLocation');
  @override
  late final GeneratedColumn<String> downloadLocation = GeneratedColumn<String>(
      'download_location', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(""));
  static const VerificationMeta _audioQualityMeta =
      const VerificationMeta('audioQuality');
  @override
  late final GeneratedColumnWithTypeConverter<SourceQualities, String>
      audioQuality = GeneratedColumn<String>(
              'audio_quality', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(SourceQualities.high.name))
          .withConverter<SourceQualities>(
              $PreferencesTableTable.$converteraudioQuality);
  static const VerificationMeta _systemTitleBarMeta =
      const VerificationMeta('systemTitleBar');
  @override
  late final GeneratedColumn<bool> systemTitleBar = GeneratedColumn<bool>(
      'system_title_bar', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("system_title_bar" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _checkUpdateMeta =
      const VerificationMeta('checkUpdate');
  @override
  late final GeneratedColumn<bool> checkUpdate = GeneratedColumn<bool>(
      'check_update', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("check_update" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _closeBehaviorMeta =
      const VerificationMeta('closeBehavior');
  @override
  late final GeneratedColumnWithTypeConverter<CloseBehavior, String>
      closeBehavior = GeneratedColumn<String>(
              'close_behavior', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: Constant(CloseBehavior.close.name))
          .withConverter<CloseBehavior>(
              $PreferencesTableTable.$convertercloseBehavior);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        downloadLocation,
        audioQuality,
        systemTitleBar,
        checkUpdate,
        closeBehavior
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PreferencesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('download_location')) {
      context.handle(
          _downloadLocationMeta,
          downloadLocation.isAcceptableOrUnknown(
              data['download_location']!, _downloadLocationMeta));
    }
    context.handle(_audioQualityMeta, const VerificationResult.success());
    if (data.containsKey('system_title_bar')) {
      context.handle(
          _systemTitleBarMeta,
          systemTitleBar.isAcceptableOrUnknown(
              data['system_title_bar']!, _systemTitleBarMeta));
    }
    if (data.containsKey('check_update')) {
      context.handle(
          _checkUpdateMeta,
          checkUpdate.isAcceptableOrUnknown(
              data['check_update']!, _checkUpdateMeta));
    }
    context.handle(_closeBehaviorMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreferencesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreferencesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      downloadLocation: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}download_location'])!,
      audioQuality: $PreferencesTableTable.$converteraudioQuality.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}audio_quality'])!),
      systemTitleBar: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}system_title_bar'])!,
      checkUpdate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}check_update'])!,
      closeBehavior: $PreferencesTableTable.$convertercloseBehavior.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}close_behavior'])!),
    );
  }

  @override
  $PreferencesTableTable createAlias(String alias) {
    return $PreferencesTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SourceQualities, String, String>
      $converteraudioQuality =
      const EnumNameConverter<SourceQualities>(SourceQualities.values);
  static JsonTypeConverter2<CloseBehavior, String, String>
      $convertercloseBehavior =
      const EnumNameConverter<CloseBehavior>(CloseBehavior.values);
}

class PreferencesTableData extends DataClass
    implements Insertable<PreferencesTableData> {
  final int id;
  final String downloadLocation;
  final SourceQualities audioQuality;
  final bool systemTitleBar;
  final bool checkUpdate;
  final CloseBehavior closeBehavior;
  const PreferencesTableData(
      {required this.id,
      required this.downloadLocation,
      required this.audioQuality,
      required this.systemTitleBar,
      required this.checkUpdate,
      required this.closeBehavior});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['download_location'] = Variable<String>(downloadLocation);
    {
      map['audio_quality'] = Variable<String>(
          $PreferencesTableTable.$converteraudioQuality.toSql(audioQuality));
    }
    map['system_title_bar'] = Variable<bool>(systemTitleBar);
    map['check_update'] = Variable<bool>(checkUpdate);
    {
      map['close_behavior'] = Variable<String>(
          $PreferencesTableTable.$convertercloseBehavior.toSql(closeBehavior));
    }
    return map;
  }

  PreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return PreferencesTableCompanion(
      id: Value(id),
      downloadLocation: Value(downloadLocation),
      audioQuality: Value(audioQuality),
      systemTitleBar: Value(systemTitleBar),
      checkUpdate: Value(checkUpdate),
      closeBehavior: Value(closeBehavior),
    );
  }

  factory PreferencesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreferencesTableData(
      id: serializer.fromJson<int>(json['id']),
      downloadLocation: serializer.fromJson<String>(json['downloadLocation']),
      audioQuality: $PreferencesTableTable.$converteraudioQuality
          .fromJson(serializer.fromJson<String>(json['audioQuality'])),
      systemTitleBar: serializer.fromJson<bool>(json['systemTitleBar']),
      checkUpdate: serializer.fromJson<bool>(json['checkUpdate']),
      closeBehavior: $PreferencesTableTable.$convertercloseBehavior
          .fromJson(serializer.fromJson<String>(json['closeBehavior'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'downloadLocation': serializer.toJson<String>(downloadLocation),
      'audioQuality': serializer.toJson<String>(
          $PreferencesTableTable.$converteraudioQuality.toJson(audioQuality)),
      'systemTitleBar': serializer.toJson<bool>(systemTitleBar),
      'checkUpdate': serializer.toJson<bool>(checkUpdate),
      'closeBehavior': serializer.toJson<String>(
          $PreferencesTableTable.$convertercloseBehavior.toJson(closeBehavior)),
    };
  }

  PreferencesTableData copyWith(
          {int? id,
          String? downloadLocation,
          SourceQualities? audioQuality,
          bool? systemTitleBar,
          bool? checkUpdate,
          CloseBehavior? closeBehavior}) =>
      PreferencesTableData(
        id: id ?? this.id,
        downloadLocation: downloadLocation ?? this.downloadLocation,
        audioQuality: audioQuality ?? this.audioQuality,
        systemTitleBar: systemTitleBar ?? this.systemTitleBar,
        checkUpdate: checkUpdate ?? this.checkUpdate,
        closeBehavior: closeBehavior ?? this.closeBehavior,
      );
  PreferencesTableData copyWithCompanion(PreferencesTableCompanion data) {
    return PreferencesTableData(
      id: data.id.present ? data.id.value : this.id,
      downloadLocation: data.downloadLocation.present
          ? data.downloadLocation.value
          : this.downloadLocation,
      audioQuality: data.audioQuality.present
          ? data.audioQuality.value
          : this.audioQuality,
      systemTitleBar: data.systemTitleBar.present
          ? data.systemTitleBar.value
          : this.systemTitleBar,
      checkUpdate:
          data.checkUpdate.present ? data.checkUpdate.value : this.checkUpdate,
      closeBehavior: data.closeBehavior.present
          ? data.closeBehavior.value
          : this.closeBehavior,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesTableData(')
          ..write('id: $id, ')
          ..write('downloadLocation: $downloadLocation, ')
          ..write('audioQuality: $audioQuality, ')
          ..write('systemTitleBar: $systemTitleBar, ')
          ..write('checkUpdate: $checkUpdate, ')
          ..write('closeBehavior: $closeBehavior')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, downloadLocation, audioQuality,
      systemTitleBar, checkUpdate, closeBehavior);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreferencesTableData &&
          other.id == this.id &&
          other.downloadLocation == this.downloadLocation &&
          other.audioQuality == this.audioQuality &&
          other.systemTitleBar == this.systemTitleBar &&
          other.checkUpdate == this.checkUpdate &&
          other.closeBehavior == this.closeBehavior);
}

class PreferencesTableCompanion extends UpdateCompanion<PreferencesTableData> {
  final Value<int> id;
  final Value<String> downloadLocation;
  final Value<SourceQualities> audioQuality;
  final Value<bool> systemTitleBar;
  final Value<bool> checkUpdate;
  final Value<CloseBehavior> closeBehavior;
  const PreferencesTableCompanion({
    this.id = const Value.absent(),
    this.downloadLocation = const Value.absent(),
    this.audioQuality = const Value.absent(),
    this.systemTitleBar = const Value.absent(),
    this.checkUpdate = const Value.absent(),
    this.closeBehavior = const Value.absent(),
  });
  PreferencesTableCompanion.insert({
    this.id = const Value.absent(),
    this.downloadLocation = const Value.absent(),
    this.audioQuality = const Value.absent(),
    this.systemTitleBar = const Value.absent(),
    this.checkUpdate = const Value.absent(),
    this.closeBehavior = const Value.absent(),
  });
  static Insertable<PreferencesTableData> custom({
    Expression<int>? id,
    Expression<String>? downloadLocation,
    Expression<String>? audioQuality,
    Expression<bool>? systemTitleBar,
    Expression<bool>? checkUpdate,
    Expression<String>? closeBehavior,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (downloadLocation != null) 'download_location': downloadLocation,
      if (audioQuality != null) 'audio_quality': audioQuality,
      if (systemTitleBar != null) 'system_title_bar': systemTitleBar,
      if (checkUpdate != null) 'check_update': checkUpdate,
      if (closeBehavior != null) 'close_behavior': closeBehavior,
    });
  }

  PreferencesTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? downloadLocation,
      Value<SourceQualities>? audioQuality,
      Value<bool>? systemTitleBar,
      Value<bool>? checkUpdate,
      Value<CloseBehavior>? closeBehavior}) {
    return PreferencesTableCompanion(
      id: id ?? this.id,
      downloadLocation: downloadLocation ?? this.downloadLocation,
      audioQuality: audioQuality ?? this.audioQuality,
      systemTitleBar: systemTitleBar ?? this.systemTitleBar,
      checkUpdate: checkUpdate ?? this.checkUpdate,
      closeBehavior: closeBehavior ?? this.closeBehavior,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (downloadLocation.present) {
      map['download_location'] = Variable<String>(downloadLocation.value);
    }
    if (audioQuality.present) {
      map['audio_quality'] = Variable<String>($PreferencesTableTable
          .$converteraudioQuality
          .toSql(audioQuality.value));
    }
    if (systemTitleBar.present) {
      map['system_title_bar'] = Variable<bool>(systemTitleBar.value);
    }
    if (checkUpdate.present) {
      map['check_update'] = Variable<bool>(checkUpdate.value);
    }
    if (closeBehavior.present) {
      map['close_behavior'] = Variable<String>($PreferencesTableTable
          .$convertercloseBehavior
          .toSql(closeBehavior.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesTableCompanion(')
          ..write('id: $id, ')
          ..write('downloadLocation: $downloadLocation, ')
          ..write('audioQuality: $audioQuality, ')
          ..write('systemTitleBar: $systemTitleBar, ')
          ..write('checkUpdate: $checkUpdate, ')
          ..write('closeBehavior: $closeBehavior')
          ..write(')'))
        .toString();
  }
}

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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LyricsTableTable lyricsTable = $LyricsTableTable(this);
  late final $PreferencesTableTable preferencesTable =
      $PreferencesTableTable(this);
  late final $ServerTableTable serverTable = $ServerTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [lyricsTable, preferencesTable, serverTable];
}

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
typedef $$PreferencesTableTableCreateCompanionBuilder
    = PreferencesTableCompanion Function({
  Value<int> id,
  Value<String> downloadLocation,
  Value<SourceQualities> audioQuality,
  Value<bool> systemTitleBar,
  Value<bool> checkUpdate,
  Value<CloseBehavior> closeBehavior,
});
typedef $$PreferencesTableTableUpdateCompanionBuilder
    = PreferencesTableCompanion Function({
  Value<int> id,
  Value<String> downloadLocation,
  Value<SourceQualities> audioQuality,
  Value<bool> systemTitleBar,
  Value<bool> checkUpdate,
  Value<CloseBehavior> closeBehavior,
});

class $$PreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTableTable> {
  $$PreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get downloadLocation => $composableBuilder(
      column: $table.downloadLocation,
      builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SourceQualities, SourceQualities, String>
      get audioQuality => $composableBuilder(
          column: $table.audioQuality,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<bool> get systemTitleBar => $composableBuilder(
      column: $table.systemTitleBar,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get checkUpdate => $composableBuilder(
      column: $table.checkUpdate, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<CloseBehavior, CloseBehavior, String>
      get closeBehavior => $composableBuilder(
          column: $table.closeBehavior,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$PreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTableTable> {
  $$PreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get downloadLocation => $composableBuilder(
      column: $table.downloadLocation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioQuality => $composableBuilder(
      column: $table.audioQuality,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get systemTitleBar => $composableBuilder(
      column: $table.systemTitleBar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get checkUpdate => $composableBuilder(
      column: $table.checkUpdate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closeBehavior => $composableBuilder(
      column: $table.closeBehavior,
      builder: (column) => ColumnOrderings(column));
}

class $$PreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTableTable> {
  $$PreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get downloadLocation => $composableBuilder(
      column: $table.downloadLocation, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SourceQualities, String> get audioQuality =>
      $composableBuilder(
          column: $table.audioQuality, builder: (column) => column);

  GeneratedColumn<bool> get systemTitleBar => $composableBuilder(
      column: $table.systemTitleBar, builder: (column) => column);

  GeneratedColumn<bool> get checkUpdate => $composableBuilder(
      column: $table.checkUpdate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CloseBehavior, String> get closeBehavior =>
      $composableBuilder(
          column: $table.closeBehavior, builder: (column) => column);
}

class $$PreferencesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PreferencesTableTable,
    PreferencesTableData,
    $$PreferencesTableTableFilterComposer,
    $$PreferencesTableTableOrderingComposer,
    $$PreferencesTableTableAnnotationComposer,
    $$PreferencesTableTableCreateCompanionBuilder,
    $$PreferencesTableTableUpdateCompanionBuilder,
    (
      PreferencesTableData,
      BaseReferences<_$AppDatabase, $PreferencesTableTable,
          PreferencesTableData>
    ),
    PreferencesTableData,
    PrefetchHooks Function()> {
  $$PreferencesTableTableTableManager(
      _$AppDatabase db, $PreferencesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> downloadLocation = const Value.absent(),
            Value<SourceQualities> audioQuality = const Value.absent(),
            Value<bool> systemTitleBar = const Value.absent(),
            Value<bool> checkUpdate = const Value.absent(),
            Value<CloseBehavior> closeBehavior = const Value.absent(),
          }) =>
              PreferencesTableCompanion(
            id: id,
            downloadLocation: downloadLocation,
            audioQuality: audioQuality,
            systemTitleBar: systemTitleBar,
            checkUpdate: checkUpdate,
            closeBehavior: closeBehavior,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> downloadLocation = const Value.absent(),
            Value<SourceQualities> audioQuality = const Value.absent(),
            Value<bool> systemTitleBar = const Value.absent(),
            Value<bool> checkUpdate = const Value.absent(),
            Value<CloseBehavior> closeBehavior = const Value.absent(),
          }) =>
              PreferencesTableCompanion.insert(
            id: id,
            downloadLocation: downloadLocation,
            audioQuality: audioQuality,
            systemTitleBar: systemTitleBar,
            checkUpdate: checkUpdate,
            closeBehavior: closeBehavior,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PreferencesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PreferencesTableTable,
    PreferencesTableData,
    $$PreferencesTableTableFilterComposer,
    $$PreferencesTableTableOrderingComposer,
    $$PreferencesTableTableAnnotationComposer,
    $$PreferencesTableTableCreateCompanionBuilder,
    $$PreferencesTableTableUpdateCompanionBuilder,
    (
      PreferencesTableData,
      BaseReferences<_$AppDatabase, $PreferencesTableTable,
          PreferencesTableData>
    ),
    PreferencesTableData,
    PrefetchHooks Function()>;
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LyricsTableTableTableManager get lyricsTable =>
      $$LyricsTableTableTableManager(_db, _db.lyricsTable);
  $$PreferencesTableTableTableManager get preferencesTable =>
      $$PreferencesTableTableTableManager(_db, _db.preferencesTable);
  $$ServerTableTableTableManager get serverTable =>
      $$ServerTableTableTableManager(_db, _db.serverTable);
}
