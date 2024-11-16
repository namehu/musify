typedef MusicApi = ({
  /// 登录校验
  Future<bool> Function(
      String _baseUrl, String _username, String _password) authenticate,
  String getSong,
});
