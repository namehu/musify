/// 列表类型
enum AlbumListTypeEnum {
  newest('newest'),

  frequent('frequent'),

  recent('recent'),

  starred('starred'),

  alphabeticalByName('alphabeticalByName'),

  alphabeticalByArtist('alphabeticalByArtist'),

  /// @support when 1.10.1
  /// see https://www.subsonic.org/pages/api.jsp#search
  byYear('byYear'),

  /// @support when 1.10.1
  byGenre('byGenre'),

  random('random');

  const AlbumListTypeEnum(this.value);

  final String value;
}
