class SongLyric {
  SongLyric({
    this.id,
    required this.lyric,
    required this.serverId,
    required this.songId,
  });

  final int? id;
  final String lyric;
  final int serverId;
  final String songId;

  factory SongLyric.fromJson(Map<String, dynamic> json) => SongLyric(
        id: json["id"],
        lyric: json["lyric"],
        serverId: json["serverId"],
        songId: json["songId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lyric": lyric,
        "serverId": serverId,
        "songId": songId,
      };
}
