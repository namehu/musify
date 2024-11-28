import 'package:get/get.dart';
import 'package:musify/services/server_service.dart';

/// 获取封面url
String getCoverArt(String id, {int size = 350}) {
  return joinServerPath('getCoverArt', {'size': size, 'id': id});
}

/// 获取音乐播放流地址
/// id: 音乐id
String getSongStream(String id) {
  return joinServerPath('stream', {'id': id});
}

String joinServerPath(String path, [Map<String, dynamic>? query]) {
  var serverService = Get.find<ServerService>();

  var query0 = joniAuthQuery(query: query, serverService: serverService);

  var qs = query0.entries
      .map((element) => '${element.key}=${element.value}')
      .join('&');

  return '${serverService.serverInfo.value.baseurl}/rest/$path?$qs';
}

Map<String, dynamic> joniAuthQuery({
  Map<String, dynamic>? query,
  ServerService? serverService,
}) {
  serverService ??= Get.find<ServerService>();
  var u = serverService.serverInfo.value.username;
  var s = serverService.serverInfo.value.salt;
  var t = serverService.serverInfo.value.hash;

  Map<String, dynamic> query0 = {
    'v': '0.0.1',
    'c': 'musify',
    'f': 'json',
    'u': u,
    's': s,
    't': t
  };

  if (query != null) {
    query0.addAll(query);
  }

  return query0;
}
