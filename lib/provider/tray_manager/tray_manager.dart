import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:musify/provider/tray_manager/tray_menu.dart';
import 'package:musify/util/platform.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class SystemTrayManager with TrayListener {
  final Ref ref;
  final bool enabled;

  SystemTrayManager(
    this.ref, {
    required this.enabled,
  }) {
    initialize();
  }

  Future<void> initialize() async {
    if (!kIsDesktop) return;

    if (enabled) {
      await trayManager.setIcon(
        kIsWindows
            ? 'assets/images/app_icon.ico'
            // : kIsFlatpak
            //     ? 'com.github.KRTirtho.Spotube'
            : 'assets/images/app_icon.png',
      );
      trayManager.addListener(this);
    } else {
      await trayManager.destroy();
    }
  }

  void dispose() {
    trayManager.removeListener(this);
  }

  @override
  onTrayIconMouseDown() {
    if (kIsWindows) {
      windowManager.show();
    } else {
      trayManager.popUpContextMenu();
    }
  }

  @override
  onTrayIconRightMouseDown() {
    if (!kIsWindows) {
      windowManager.show();
    } else {
      trayManager.popUpContextMenu();
    }
  }
}

final trayManagerProvider = Provider(
  (ref) {
    final manager = SystemTrayManager(
      ref,
      enabled: true,
    );

    ref.listen(trayMenuProvider, (_, menu) {
      if (!kIsDesktop) return;

      trayManager.setContextMenu(menu);
    });

    var menu = ref.read(trayMenuProvider);
    trayManager.setContextMenu(menu);

    ref.onDispose(manager.dispose);

    return manager;
  },
);
