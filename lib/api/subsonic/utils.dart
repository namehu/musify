import 'package:get/get.dart';
import 'package:musify/services/server_service.dart';

String getCoverArt(String _id, {int size = 350}) {
  return joinServerPath('getCoverArt', {'size': size, 'id': _id});
}

String joinServerPath(String path, [Map<String, dynamic>? query]) {
  var serverService = Get.find<ServerService>();

  var _query = joniAuthQuery(query: query, serverService: serverService);

  var _qs = _query.entries
      .map((element) => '${element.key}=${element.value}')
      .join('&');

  return serverService.serverInfo.value.baseurl + '/rest/$path?$_qs';
}

Map<String, dynamic> joniAuthQuery({
  Map<String, dynamic>? query,
  ServerService? serverService,
}) {
  serverService ??= Get.find<ServerService>();
  var u = serverService.serverInfo.value.username;
  var s = serverService.serverInfo.value.salt;
  var t = serverService.serverInfo.value.hash;

  Map<String, dynamic> _query = {
    'v': '0.0.1',
    'c': 'musify',
    'f': 'json',
    'u': u,
    's': s,
    't': t
  };

  if (query != null) {
    _query.addAll(query);
  }

  return _query;
}
