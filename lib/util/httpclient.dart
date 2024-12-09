// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings

import 'package:dio/dio.dart';
import '../models/notifierValue.dart';

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

getCoverArt(String _id, {int size = 350}) {
  String _sql = _getServerInfo("getCoverArt");
  return _sql + '&size=$size' + '&id=' + _id;
}

_getServerInfo(String _api) {
  String _request = serversInfo.value.baseurl +
      '/rest/$_api?v=0.0.1&c=musify&f=json&u=' +
      serversInfo.value.username +
      '&s=' +
      serversInfo.value.salt +
      '&t=' +
      serversInfo.value.hash;
  return _request;
}

getRandomSongs() async {
  String _sql = _getServerInfo("getRandomSongs");
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _randomSongs = _subsonic['randomSongs'];
    return _randomSongs;
  } catch (e) {
    print(e);
    return null;
  }
}

/// 查询专辑信息
/// Requires Last.fm and Spotify integration
getAlbumInfo2(String _albumId) async {
  String _sql = _getServerInfo("getAlbumInfo2") + '&id=' + _albumId;
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _albumInfo = _subsonic['albumInfo'];
    return _albumInfo;
  } catch (e) {
    print(e);
    return null;
  }
}

search3(String _query) async {
  String _sql = _getServerInfo("search3") + '&query=' + _query;
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _searchResult3 = _subsonic['searchResult3'];
    return _searchResult3;
  } catch (e) {
    print(e);
    return null;
  }
}

updatePlaylist(String playlistId, String songIdToAdd) async {
  String _sql = await _getServerInfo("updatePlaylist");
  _sql = _sql + '&playlistId=' + playlistId + '&songIdToAdd=' + songIdToAdd;
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    return _subsonic;
  } catch (e) {
    print(e);
    return null;
  }
}

delSongfromPlaylist(String playlistId, String? index) async {
  String _sql = await _getServerInfo("updatePlaylist");
  _sql = _sql +
      '&playlistId=' +
      playlistId +
      '&songIndexToRemove=' +
      index.toString();
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    return _subsonic;
  } catch (e) {
    print(e);
    return null;
  }
}

getPlaylist(String _id) async {
  String _sql = await _getServerInfo("getPlaylist");
  try {
    var _response = await Dio().get(_sql + "&id=" + _id);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _playlist = _subsonic['playlist'];
    List _songs = _playlist['entry'];
    return _songs;
  } catch (e) {
    print(e);
    return null;
  }
}

getArtists() async {
  String _sql = await _getServerInfo("getArtists");
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _artists = _subsonic['artists'];
    return _artists;
  } catch (e) {
    print(e);
    return null;
  }
}

getArtistInfo2(String _id) async {
  String _sql = await _getServerInfo("getArtistInfo2");
  try {
    var _response = await Dio().get(
      _sql + '&count=10' + '&id=' + _id,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _artistInfo2 = _subsonic['artistInfo2'];
    return _artistInfo2;
  } catch (e) {
    print(e);
    return null;
  }
}

getArtist(String _id) async {
  String _sql = await _getServerInfo("getArtist");
  try {
    var _response = await Dio().get(
      _sql + '&id=' + _id,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _artist = _subsonic['artist'];
    return _artist;
  } catch (e) {
    print(e);
    return null;
  }
}

//count no 50
getTopSongs(String _name) async {
  String _sql = await _getServerInfo("getTopSongs");
  try {
    var _response = await Dio().get(
      _sql + '&artist=' + _name,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _topSongs = _subsonic['topSongs'];
    return _topSongs;
  } catch (e) {
    print(e);
    return null;
  }
}

getSong(String _id) async {
  String _sql = await _getServerInfo("getSong");
  try {
    var _response = await Dio().get(
      _sql + '&id=' + _id,
    );
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _song = _subsonic['song'];
    return _song;
  } catch (e) {
    print(e);
    return null;
  }
}

getStarred() async {
  String _sql = await _getServerInfo("getStarred2");
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    Map _starred = _subsonic['starred2'];
    return _starred;
  } catch (e) {
    print(e);
    return null;
  }
}

createShare(String _id, {String description = ""}) async {
  String _sql = await _getServerInfo("createShare");
  try {
    var _response =
        await Dio().get(_sql + "&id=" + _id + "&description=" + description);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    if (_subsonic['shares'] == null) return null;
    Map _shares = _subsonic['shares'];
    if (_shares['share'] == null) return null;
    List _share = _shares['share'];
    return _share;
  } catch (e) {
    print(e);
    return null;
  }
}

scrobble(String _songId, bool _submission) async {
  String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String _sql =
      await _getServerInfo("scrobble") + '&time=$_timestamp' + '&id=' + _songId;
  try {
    var _response = await Dio().get(_sql);
    var _subsonic = checkResponse(_response);
    if (_subsonic == null) return null;
    return _subsonic;
  } catch (e) {
    print(e);
    return null;
  }
}

searchNeteasAPI(String _name, String _type) async {
  String _neteaseapi = serversInfo.value.neteaseapi;
  String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String _request = _neteaseapi +
      "/search?limit=5&type=$_type&offset=0&keywords=$_name&timestamp=$_timestamp";
  print(_request);
  try {
    var response = await Dio().get(_request);
    if (response.statusCode == 200) {
      var _result = response.data['result'];
      if (_result == null) return null;
      return _result;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

getLyric(String _songId) async {
  String _neteaseapi = serversInfo.value.neteaseapi;
  String _timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  String _request = _neteaseapi + "/lyric?id=$_songId&timestamp=$_timestamp";
  try {
    var response = await Dio().get(_request);
    if (response.statusCode == 200) {
      var _value = response.data['lrc'];
      if (_value == null) return null;
      var _lyric = _value["lyric"];
      if (_lyric == null) return null;
      return _lyric;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}
