import 'package:dio/dio.dart';

import '../../util/mycss.dart';
import '../types.dart';

MusicApi navidromeApi = (
  authenticate: authenticate,
  getSong: 'https://api.music.163.com/api/linux/forward',
);

checkResponse(Response<dynamic> _response) {
  if (_response.statusCode == 200) {
    if (_response.data['subsonic-response'] != null) {
      Map _subsonic = _response.data['subsonic-response'];
      String _status = _subsonic['status'];
      if (_status == 'ok') {
        return _subsonic;
      }
    }
  }
  return null;
}

Future<bool> authenticate(
    String _baseUrl, String _username, String _password) async {
  try {
    var _response = await Dio().get(
      _baseUrl +
          '/rest/ping?v=$version&c=musify&f=json&u=' +
          _username +
          '&p=' +
          _password,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return false;
    return true;
  } catch (e) {
    print(e);
  }
  return false;
}
