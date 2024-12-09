import 'dart:convert';
import 'package:musify/constant.dart';
import 'package:musify/models/songs.dart';

class NdLyrics {
  NdLyrics({
    required this.lang,
    required this.line,
  });

  // 语言
  final String lang;
  // 歌词文本
  final List<NdLyricsLine> line;

  // 从json中转换
  factory NdLyrics.fromJson(Map<String, dynamic> json) => NdLyrics(
        lang: json['lang'] ?? "",
        line: json['line'] == null
            ? []
            : (json['line'] as List)
                .map((e) => NdLyricsLine.fromJson(e))
                .toList(),
      );

  // 从歌曲内置歌词中转换
  factory NdLyrics.fromJsonString(String jsonString) {
    try {
      List<dynamic> jsonArr = jsonDecode(jsonString);
      return NdLyrics.fromJson(jsonArr[0]);
    } catch (e) {
      logger.e('解析歌词失败');
    }
    return NdLyrics(lang: '', line: []);
  }

// 转换成json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lang'] = lang;
    data['line'] = line.map((e) => e.toJson());
    return data;
  }

  /// 将start时间转换为[00:00.45] 格式
  String toPlayerlyric([Songs? song]) {
    String text = line.map((e) {
      String text = '';

      if (e.value != null && e.start != null) {
        text += _formatLyircTimeString(e.start!);
        text += e.value!;
      }
      return text;
    }).join("\n");

    // 处理歌词头部
    if (song != null) {
      if (!text.contains('[ti:') && !text.contains('[offset:')) {
        text = [
              '[ti:${song.title}]',
              '[ar:${song.artist}]',
              '[al:${song.album}]',
              '[by:]',
              '[offset:0]\n'
            ].join('\n') +
            text;
      }
    }

    return text;
  }

  String _formatLyircTimeString(int milliseconds) {
    // 计算分钟、秒和毫秒
    int minutes = (milliseconds / 60000).floor();
    int seconds = ((milliseconds % 60000) / 1000).floor();
    int remainingMilliseconds = milliseconds % 1000;

    // 格式化字符串
    return '[${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${remainingMilliseconds.toString().padLeft(2, '0')}]';
  }
}

class NdLyricsLine {
  int? start;
  String? value;

  NdLyricsLine({
    this.start,
    this.value,
  });

  NdLyricsLine.fromJson(Map<String, dynamic> json) {
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
