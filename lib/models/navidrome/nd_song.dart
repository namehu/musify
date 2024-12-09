import 'package:json_annotation/json_annotation.dart';
part 'nd_song.g.dart';

@JsonSerializable()
class NdSong {
  @JsonKey(name: 'playCount')
  int? playCount;
  @JsonKey(name: 'playDate')
  String? playDate;
  @JsonKey(name: 'rating')
  int? rating;
  @JsonKey(name: 'starred')
  bool? starred;
  @JsonKey(name: 'starredAt')
  String? starredAt;
  @JsonKey(name: 'bookmarkPosition')
  int? bookmarkPosition;
  @JsonKey(name: 'id')
  String? id;
  @JsonKey(name: 'path')
  String? path;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'album')
  String? album;
  @JsonKey(name: 'artistId')
  String? artistId;
  @JsonKey(name: 'artist')
  String? artist;
  @JsonKey(name: 'albumArtistId')
  String? albumArtistId;
  @JsonKey(name: 'albumArtist')
  String? albumArtist;
  @JsonKey(name: 'albumId')
  String? albumId;
  @JsonKey(name: 'hasCoverArt')
  bool? hasCoverArt;
  @JsonKey(name: 'trackNumber')
  int? trackNumber;
  @JsonKey(name: 'discNumber')
  int? discNumber;
  @JsonKey(name: 'year')
  int? year;
  @JsonKey(name: 'originalYear')
  int? originalYear;
  @JsonKey(name: 'releaseYear')
  int? releaseYear;
  @JsonKey(name: 'size')
  int? size;
  @JsonKey(name: 'suffix')
  String? suffix;
  @JsonKey(name: 'duration')
  double? duration;
  @JsonKey(name: 'bitRate')
  int? bitRate;
  @JsonKey(name: 'channels')
  int? channels;
  @JsonKey(name: 'genre')
  String? genre;
  @JsonKey(name: 'genres')
  List<dynamic>? genres;
  @JsonKey(name: 'fullText')
  String? fullText;
  @JsonKey(name: 'orderTitle')
  String? orderTitle;
  @JsonKey(name: 'orderAlbumName')
  String? orderAlbumName;
  @JsonKey(name: 'orderArtistName')
  String? orderArtistName;
  @JsonKey(name: 'orderAlbumArtistName')
  String? orderAlbumArtistName;
  @JsonKey(name: 'compilation')
  bool? compilation;
  @JsonKey(name: 'lyrics')
  String? lyrics;
  @JsonKey(name: 'rgAlbumGain')
  int? rgAlbumGain;
  @JsonKey(name: 'rgAlbumPeak')
  int? rgAlbumPeak;
  @JsonKey(name: 'rgTrackGain')
  int? rgTrackGain;
  @JsonKey(name: 'rgTrackPeak')
  int? rgTrackPeak;
  @JsonKey(name: 'createdAt')
  String? createdAt;
  @JsonKey(name: 'updatedAt')
  String? updatedAt;

  NdSong(
      {this.playCount,
      this.playDate,
      this.rating,
      this.starred,
      this.starredAt,
      this.bookmarkPosition,
      this.id,
      this.path,
      this.title,
      this.album,
      this.artistId,
      this.artist,
      this.albumArtistId,
      this.albumArtist,
      this.albumId,
      this.hasCoverArt,
      this.trackNumber,
      this.discNumber,
      this.year,
      this.originalYear,
      this.releaseYear,
      this.size,
      this.suffix,
      this.duration,
      this.bitRate,
      this.channels,
      this.genre,
      this.genres,
      this.fullText,
      this.orderTitle,
      this.orderAlbumName,
      this.orderArtistName,
      this.orderAlbumArtistName,
      this.compilation,
      this.lyrics,
      this.rgAlbumGain,
      this.rgAlbumPeak,
      this.rgTrackGain,
      this.rgTrackPeak,
      this.createdAt,
      this.updatedAt});

  factory NdSong.fromJson(Map<String, dynamic> json) => _$NdSongFromJson(json);

  static List<NdSong> fromList(List<Map<String, dynamic>> list) {
    return list.map(NdSong.fromJson).toList();
  }

  Map<String, dynamic> toJson() => _$NdSongToJson(this);
}
