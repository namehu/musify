/// 流派
class Genres {
  late String value;
  late int songCount;
  late int albumCount;

  Genres({
    required this.value,
    required this.songCount,
    required this.albumCount,
  });

  Genres.fromJson(Map<String, dynamic> json) {
    value = json['value'] ?? '';
    songCount = json['songCount'] ?? 0;
    albumCount = json['albumCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['songCount'] = songCount;
    data['albumCount'] = albumCount;
    return data;
  }
}
