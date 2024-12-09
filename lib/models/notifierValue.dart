// ignore_for_file: file_names

import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:musify/enums/serve_type_enum.dart';

import 'myModel.dart';

ValueNotifier<ServerInfo> serversInfo = ValueNotifier<ServerInfo>(ServerInfo(
  serverType: ServeTypeEnum.subsnoic.label,
  baseurl: '',
  userId: '',
  username: '',
  password: '',
  salt: '',
  hash: '',
  ndCredential: '',
  neteaseapi: '',
  languageCode: '',
));

//监听当前资源ID 艺人/专辑/歌曲都是它
ValueNotifier<String> activeID = ValueNotifier<String>("1");

ValueNotifier<double> windowsWidth = ValueNotifier<double>(
    PlatformDispatcher.instance.views.first.physicalSize.width /
        PlatformDispatcher.instance.views.first.devicePixelRatio);

ValueNotifier<double> windowsHeight = ValueNotifier<double>(
    PlatformDispatcher.instance.views.first.physicalSize.height /
        PlatformDispatcher.instance.views.first.devicePixelRatio);

ValueNotifier<bool> hideMusicBar = ValueNotifier<bool>(false);
