import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:musify/enums/close_behavior.dart';
import 'package:musify/services/preferences_service.dart';
import 'package:musify/util/platform.dart';
import 'use_window_listener.dart';
// import 'package:spotube/models/database/database.dart';
// import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

import 'package:local_notifier/local_notifier.dart';
import 'package:window_manager/window_manager.dart';

final closeNotification = !kIsDesktop
    ? null
    : (LocalNotification(
        title: 'Spotube',
        body: 'Running in background. Minimized to System Tray',
        actions: [
          LocalNotificationAction(text: 'Close The App'),
        ],
      )..onClickAction = (value) {
        exit(0);
      });

void useCloseBehavior(WidgetRef ref) {
  useWindowListener(
    onWindowClose: () async {
      final closeBehavior = PreferencesService.closeBehavior;
      if (closeBehavior == CloseBehavior.minimizeToTray) {
        await windowManager.hide();
        closeNotification?.show();
      } else {
        exit(0);
      }
    },
  );
}
