typedef MusicApi = ({
  /// 登录校验
  Future<Map<String, dynamic>> Function(
      String _baseUrl, String _username, String _password) authenticate,
  String getSong,
});
