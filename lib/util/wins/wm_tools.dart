import 'package:flutter/material.dart';
import 'package:musify/services/preferences_service.dart';
import 'package:window_manager/window_manager.dart';

import '../platform.dart';

class WindowSize {
  final double height;
  final double width;
  final bool maximized;

  WindowSize({
    required this.height,
    required this.width,
    required this.maximized,
  });

  factory WindowSize.fromJson(Map<String, dynamic> json) => WindowSize(
        height: json["height"],
        width: json["width"],
        maximized: json["maximized"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "width": width,
        "maximized": maximized,
      };
}

class WindowManagerTools with WidgetsBindingObserver {
  static WindowManagerTools? _instance;
  static WindowManagerTools get instance => _instance!;

  WindowManagerTools._();

  static Future<void> initialize() async {
    await windowManager.ensureInitialized();
    _instance = WindowManagerTools._();
    WidgetsBinding.instance.addObserver(instance);

    const WindowOptions windowOptions = WindowOptions(
      title: "Musify",
      size: Size(1280, 800),
      minimumSize: Size(800, 600),
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      center: true,
    );

    await windowManager.waitUntilReadyToShow(
      windowOptions,
      () async {
        final savedSize = PreferencesService.windowSize;
        await windowManager.setResizable(true);
        if (savedSize?.maximized == true &&
            !(await windowManager.isMaximized())) {
          await windowManager.maximize();
        } else if (savedSize != null) {
          await windowManager.setSize(Size(savedSize.width, savedSize.height));
        }

        // await windowManager.focus();
        // await windowManager.show();
      },
    );
  }

  Size? _prevSize;

  @override
  void didChangeMetrics() async {
    super.didChangeMetrics();
    if (kIsMobile) return;
    final size = await windowManager.getSize();
    final windowSameDimension =
        _prevSize?.width == size.width && _prevSize?.height == size.height;

    if (windowSameDimension || _prevSize == null) {
      _prevSize = size;
      return;
    }
    final isMaximized = await windowManager.isMaximized();
    await PreferencesService.setWindowSize(
      WindowSize(
        height: size.height,
        width: size.width,
        maximized: isMaximized,
      ),
    );
    _prevSize = size;
  }
}
