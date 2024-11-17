class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class ServerInfo {
  int? id;
  late String serverType;
  late String baseurl;
  late String userId;
  late String username;
  late String salt;
  late String hash;
  late String ndCredential;
  late String neteaseapi;
  late String languageCode;

  ServerInfo({
    required this.serverType,
    required this.baseurl,
    required this.userId,
    required this.username,
    required this.salt,
    required this.hash,
    required this.ndCredential,
    required this.neteaseapi,
    required this.languageCode,
  });

  ServerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serverType = json['serverType'];
    baseurl = json['baseurl'];
    userId = json['userId'];
    username = json['username'];
    salt = json['salt'];
    hash = json['hash'];
    ndCredential = json['ndCredential'];
    neteaseapi = json['neteaseapi'];
    languageCode = json['languageCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['serverType'] = this.serverType;
    _data['baseurl'] = this.baseurl;
    _data['userId'] = this.userId;
    _data['username'] = this.username;
    _data['salt'] = this.salt;
    _data['hash'] = this.hash;
    _data['ndCredential'] = this.ndCredential;
    _data['neteaseapi'] = this.neteaseapi;
    _data['languageCode'] = this.languageCode;
    return _data;
  }
}

class ServerStatus {
  late int count;
  late String lastScan;

  ServerStatus({required this.count, required this.lastScan});

  ServerStatus.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    lastScan = json['lastScan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['count'] = this.count;
    _data['lastScan'] = this.lastScan;
    return _data;
  }
}

class Playlist {
  late String id;
  late String name;
  late int songCount;
  late int duration;
  late int public;
  late String owner;
  late String created;
  late String changed;
  late String imageUrl;

  Playlist(
      {required this.id,
      required this.name,
      required this.songCount,
      required this.duration,
      required this.public,
      required this.owner,
      required this.created,
      required this.changed,
      required this.imageUrl});

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    songCount = json['songCount'];
    duration = json['duration'];
    public = json['public'] ? 0 : 1;
    owner = json['owner'];
    created = json['created'];
    changed = json['changed'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['name'] = this.name;
    _data['songCount'] = this.songCount;
    _data['duration'] = this.duration;
    _data['public'] = this.public;
    _data['owner'] = this.owner;
    _data['created'] = this.created;
    _data['changed'] = this.changed;
    _data['imageUrl'] = this.imageUrl;

    return _data;
  }
}

class Sharelist {
  late String id;
  late String url;
  late String description;
  late String username;
  late String created;
  late String expires;
  late String lastVisited;
  late int visitCount;

  Sharelist(
      {required this.id,
      required this.url,
      required this.description,
      required this.username,
      required this.created,
      required this.expires,
      required this.lastVisited,
      required this.visitCount});

  Sharelist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    description = json['description'];
    username = json['username'];
    created = json['created'];
    expires = json['expires'];
    lastVisited = json['lastVisited'];
    visitCount = json['visitCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['url'] = this.url;
    _data['description'] = this.description;
    _data['username'] = this.username;
    _data['created'] = this.created;
    _data['expires'] = this.expires;
    _data['lastVisited'] = this.lastVisited;
    _data['visitCount'] = this.visitCount;

    return _data;
  }
}

class Genres {
  late String value;
  late int songCount;
  late int albumCount;

  Genres(
      {required this.value, required this.songCount, required this.albumCount});

  Genres.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    songCount = json['songCount'];
    albumCount = json['albumCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['value'] = this.value;
    _data['songCount'] = this.songCount;
    _data['albumCount'] = this.albumCount;

    return _data;
  }
}

class Artists {
  late String id;
  late String name;
  late int albumCount;
  late String artistImageUrl;

  Artists(
      {required this.id,
      required this.name,
      required this.albumCount,
      required this.artistImageUrl});

  Artists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    albumCount = json['albumCount'];
    artistImageUrl = json['artistImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['name'] = this.name;
    _data['albumCount'] = this.albumCount;
    _data['artistImageUrl'] = this.artistImageUrl;

    return _data;
  }
}

class Albums {
  late String id;
  late String artistId;
  late String title;
  late String artist;
  late String genre;
  late int year;
  late int duration;
  late int playCount;
  late int songCount;
  late String created;
  late String coverUrl;

  Albums(
      {required this.id,
      required this.artistId,
      required this.title,
      required this.artist,
      required this.genre,
      required this.year,
      required this.duration,
      required this.playCount,
      required this.songCount,
      required this.created,
      required this.coverUrl});

  Albums.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    artistId = json['artistId'] ?? '';
    title = json['title'] ?? '';
    artist = json['artist'] ?? '';
    genre = json['genre'] == null ? "" : json['genre'];
    year = json['year'] == null ? 0 : json['year'];
    duration = json['duration'] == null ? 0 : json['duration'];
    playCount = json['playCount'] == null ? 0 : json['playCount'];
    songCount = json['songCount'] ?? 0;
    created = json['created'] ?? '';
    coverUrl = json['coverUrl'] ?? '';
  }

  get length => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['artistId'] = this.artistId;
    _data['title'] = this.title;
    _data['artist'] = this.artist;
    _data['genre'] = this.genre;
    _data['year'] = this.year;
    _data['duration'] = this.duration;
    _data['playCount'] = this.playCount;
    _data['songCount'] = this.songCount;
    _data['created'] = this.created;
    _data['coverUrl'] = this.coverUrl;
    return _data;
  }
}

class SongsAndLyric {
  late String lyric;
  late String songId;

  SongsAndLyric({required this.lyric, required this.songId});

  SongsAndLyric.fromJson(Map<String, dynamic> json) {
    lyric = json['lyric'];
    songId = json['songId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['lyric'] = this.lyric;
    _data['songId'] = this.songId;

    return _data;
  }
}

class Favorite {
  late String id;
  late String type;

  Favorite({required this.id, required this.type});

  Favorite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['type'] = this.type;

    return _data;
  }
}
