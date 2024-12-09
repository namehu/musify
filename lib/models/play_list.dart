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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['songCount'] = songCount;
    data['duration'] = duration;
    data['public'] = public;
    data['owner'] = owner;
    data['created'] = created;
    data['changed'] = changed;
    data['imageUrl'] = imageUrl;
    data['songs'] = songs!.toList();

    return data;
  }
}
