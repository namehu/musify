import 'package:musify/models/songs.dart';

class Playlist {
  late String id;
  late String name;
  late int songCount;
  late int duration;
  late int public;
  late String owner;
  late String created;
  late String changed;
  late String imageUrl;
  List<Songs>? songs;

  Playlist({
    required this.id,
    required this.name,
    required this.songCount,
    required this.duration,
    required this.public,
    required this.owner,
    required this.created,
    required this.changed,
    required this.imageUrl,
    this.songs = const <Songs>[],
  });

  Playlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    songCount = json['songCount'];
    duration = json['duration'];
    public = json['public'] ? 0 : 1;
    owner = json['owner'];
    created = json['created'];
    changed = json['changed'];
    imageUrl = json['imageUrl'];
    songs = <Songs>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = new Map<String, dynamic>();
    _data['id'] = this.id;
    _data['name'] = this.name;
    _data['songCount'] = this.songCount;
    _data['duration'] = this.duration;
    _data['public'] = this.public;
    _data['owner'] = this.owner;
    _data['created'] = this.created;
    _data['changed'] = this.changed;
    _data['imageUrl'] = this.imageUrl;
    _data['songs'] = this.songs!.toList();

    return _data;
  }
}
