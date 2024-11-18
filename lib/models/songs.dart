import 'package:musify/models/navidrome/nd_song.dart';

class Songs {
  late String id;
  late String title;
  late String album;
  late String artist;
  late String genre;
  late String albumId;
  late int duration;
  late int bitRate;
  late String suffix;
  late String path;
  late int playCount;
  late String created;
  late String stream;
  late String coverUrl;
  late String lyrics;
  late bool starred;

  Songs({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    required this.genre,
    required this.albumId,
    required this.duration,
    required this.bitRate,
    required this.suffix,
    required this.path,
    required this.playCount,
    required this.created,
    required this.stream,
    required this.coverUrl,
    required this.lyrics,
    required this.starred,
  });

  Songs.fromJson(Map<String, dynamic> json) {
    id = json['id'] == null ? "" : json['id'];
    title = json['title'] == null ? "" : json['title'];
    album = json['album'] == null ? "" : json['album'];
    artist = json['artist'] == null ? "" : json['artist'];
    genre = json['genre'] == null ? "0" : json['genre'];
    albumId = json['albumId'] == null ? "" : json['albumId'];
    duration = json['duration'] == null ? 0 : json['duration'];
    bitRate = json['bitRate'] == null ? 0 : json['bitRate'];
    suffix = json['suffix'] == null ? "" : json['suffix'];
    path = json['path'] == null ? "" : json['path'];
    playCount = json['playCount'] == null ? 0 : json['playCount'];
    created = json['created'] == null ? "" : json['created'];
    stream = json['stream'] == null ? "" : json['stream'];
    coverUrl = json['coverUrl'] == null ? "" : json['coverUrl'];
    lyrics = json['lyrics'] == null ? "" : json['lyrics'];

    if (json['starred'] == null) {
      starred = false;
    } else if (json['starred'] is bool) {
      starred = json['starred'];
    } else if (json['starred'] is String) {
      starred = json['starred'] == '' ? false : true;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['title'] = this.title;
    _data['album'] = this.album;
    _data['artist'] = this.artist;
    _data['genre'] = this.genre;
    _data['albumId'] = this.albumId;
    _data['duration'] = this.duration;
    _data['bitRate'] = this.bitRate;
    _data['suffix'] = this.suffix;
    _data['path'] = this.path;
    _data['playCount'] = this.playCount;
    _data['created'] = this.created;
    _data['stream'] = this.stream;
    _data['coverUrl'] = this.coverUrl;
    _data['lyrics'] = this.lyrics;
    _data['starred'] = this.starred;
    return _data;
  }

  Songs.fromNdSong(NdSong ndsong) {
    id = ndsong.id ?? '';
    title = ndsong.title ?? '';
    album = ndsong.album ?? '';
    artist = ndsong.artist ?? '';
    genre = ndsong.genre ?? '0';
    albumId = ndsong.albumId ?? '';
    duration = ndsong.duration?.toInt() ?? 0;
    bitRate = ndsong.bitRate ?? 0;
    suffix = ndsong.suffix ?? '';
    path = ndsong.path ?? '';
    playCount = ndsong.playCount ?? 0;
    created = ndsong.createdAt ?? '';
    starred = ndsong.starred ?? false;
    lyrics = ndsong.lyrics ?? '';
  }

  Songs.fromInitial() {
    id = "";
    title = "";
    album = "";
    artist = "";
    genre = "0";
    albumId = "";
    duration = 0;
    bitRate = 0;
    suffix = "";
    path = "";
    playCount = 0;
    created = "";
    stream = "";
    coverUrl = "";
    lyrics = '';
    starred = false;
  }
}
