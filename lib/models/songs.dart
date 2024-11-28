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
    id = json['id'] ?? "";
    title = json['title'] ?? "";
    album = json['album'] ?? "";
    artist = json['artist'] ?? "";
    genre = json['genre'] ?? "0";
    albumId = json['albumId'] ?? "";
    duration = json['duration'] ?? 0;
    bitRate = json['bitRate'] ?? 0;
    suffix = json['suffix'] ?? "";
    path = json['path'] ?? "";
    playCount = json['playCount'] ?? 0;
    created = json['created'] ?? "";
    stream = json['stream'] ?? "";
    coverUrl = json['coverUrl'] ?? "";
    lyrics = json['lyrics'] ?? "";

    if (json['starred'] == null) {
      starred = false;
    } else if (json['starred'] is bool) {
      starred = json['starred'];
    } else if (json['starred'] is String) {
      starred = json['starred'] == '' ? false : true;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['album'] = album;
    data['artist'] = artist;
    data['genre'] = genre;
    data['albumId'] = albumId;
    data['duration'] = duration;
    data['bitRate'] = bitRate;
    data['suffix'] = suffix;
    data['path'] = path;
    data['playCount'] = playCount;
    data['created'] = created;
    data['stream'] = stream;
    data['coverUrl'] = coverUrl;
    data['lyrics'] = lyrics;
    data['starred'] = starred;
    return data;
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
