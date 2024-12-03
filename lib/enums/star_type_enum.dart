/// 收藏类型
enum StarTypeEnum {
  /// 艺术家
  artist('artist'),

  /// 专辑
  album('album'),

  /// 歌曲
  song('song');

  final String value;

  const StarTypeEnum(this.value);
}
