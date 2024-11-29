import 'dart:convert';

import 'package:musify/constant.dart';
import 'package:musify/util/util.dart';

class Lyrics {
  // 语言
  late String lang;
  // 歌词文本
  late List<LyricsLine> line;

  Lyrics({
    required this.lang,
    required this.line,
  });

  // 从json中转换
  factory Lyrics.fromJson(Map<String, dynamic> json) => Lyrics(
        lang: json['lang'] ?? "",
        line: json['line'] == null
            ? []
            : (json['line'] as List)
                .map((e) => LyricsLine.fromJson(e))
                .toList(),
      );

  // 从歌曲内置歌词中转换
  factory Lyrics.fromJsonString(String jsonString) {
    try {
      List<dynamic> jsonArr = jsonDecode(jsonString);
      return Lyrics.fromJson(jsonArr[0]);
    } catch (e) {
      logger.e('解析歌词失败');
    }
    return Lyrics(lang: '', line: []);
  }

// 转换成json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lang'] = lang;
    data['line'] = line.map((e) => e.toJson());
    return data;
  }

  // 将start时间转换为[00:00.45] 格式
  String toPlayerlyric() => line.map((e) {
        String text = '';

        if (e.value != null && e.start != null) {
          text += formatLyircTimeString(e.start!);
          text += e.value!;
        }
        return text;
      }).join("\n");
}

class LyricsLine {
  int? start;
  String? value;

  LyricsLine({
    this.start,
    this.value,
  });

  LyricsLine.fromJson(Map<String, dynamic> json) {
    start = json['start'] ?? 0;
    value = json['value'] ?? "";
  }

  toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['value'] = value;
    return data;
  }
}
