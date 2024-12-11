import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:musify/util/platform.dart';
import 'package:window_manager/window_manager.dart';

void useFixWindowStretching() {
  useEffect(() {
    if (!kIsWindows) return;
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) async {
      await Future<void>.delayed(const Duration(milliseconds: 100), () {
        windowManager.getSize().then((Size value) {
          windowManager.setSize(
            Size(value.width + 1, value.height + 1),
          );
        });
      });
    });

    return null;
  }, []);
}