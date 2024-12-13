import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:musify/enums/size_enums.dart';
import 'package:musify/generated/l10n.dart';
import 'package:musify/provider/user_preferences/user_preferences_provider.dart';
import 'package:musify/routes/pages.dart';
import 'package:musify/services/global_service.dart';
import 'package:musify/services/theme_service.dart';
import 'package:musify/styles/size.dart';
import 'package:musify/util/mycss.dart';
import 'package:musify/util/platform.dart';
import 'package:musify/views/setting/setting_controller.dart';
import 'package:musify/views/setting/widgets/appearance.dart';
import 'package:musify/views/setting/widgets/downloads.dart';
import 'package:musify/views/setting/widgets/language_region.dart';
import 'package:musify/widgets/m_button.dart';
import 'package:musify/widgets/m_title.dart';
import 'package:musify/widgets/titlebar/titlebar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:musify/extensions/context.dart';

class SettingBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<SettingController>(SettingController());
  }
}

class SettingView extends HookConsumerWidget {
  static const name = "settings";

  const SettingView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final controller = useScrollController();
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: PageWindowTitleBar(
          title: Text(context.l10n.settings),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: Scrollbar(
          controller: controller,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1366),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(scrollbars: false),
                child: ListView(
                  controller: controller,
                  children: [
                    // const SettingsAccountSection(),
                    const SettingsLanguageRegionSection(),
                    const SettingsAppearanceSection(),
                    // const SettingsPlaybackSection(),
                    const SettingsDownloadsSection(),
                    // if (kIsDesktop) const SettingsDesktopSection(),
                    // if (!kIsWeb) const SettingsDevelopersSection(),
                    // const SettingsAboutSection(),
                    Center(
                      child: FilledButton(
                        onPressed: preferencesNotifier.reset,
                        child: Text(context.l10n.restore_defaults),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
