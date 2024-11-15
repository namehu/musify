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
  });

  Songs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    album = json['album'];
    artist = json['artist'];
    genre = json['genre'] == null ? "0" : json['genre'];
    albumId = json['albumId'];
    duration = json['duration'] == null ? 0 : json['duration'];
    bitRate = json['bitRate'] == null ? 0 : json['bitRate'];
    suffix = json['suffix'];
    path = json['path'];
    playCount = json['playCount'] == null ? 0 : json['playCount'];
    created = json['created'];
    stream = json['stream'];
    coverUrl = json['coverUrl'];
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
    return _data;
  }
}
