import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:musify/collections/spotube_icons.dart';
import 'package:musify/modules/settings/color_scheme_picker_dialog.dart';
import 'package:musify/modules/settings/section_card_with_heading.dart';
import 'package:musify/widgets/adaptive/adaptive_select_tile.dart';
import 'package:musify/extensions/context.dart';
import 'package:musify/provider/user_preferences/user_preferences_provider.dart';

class SettingsAppearanceSection extends HookConsumerWidget {
  final bool isGettingStarted;
  const SettingsAppearanceSection({
    super.key,
    this.isGettingStarted = false,
  });

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);
    final pickColorScheme = useCallback(() {
      return () => showDialog(
          context: context,
          builder: (context) {
            return const ColorSchemePickerDialog();
          });
    }, []);

    final children = [
      AdaptiveSelectTile<ThemeMode>(
        secondary: const Icon(SpotubeIcons.darkMode),
        title: Text(context.l10n.theme),
        value: preferences.themeMode,
        options: [
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text(context.l10n.dark),
          ),
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text(context.l10n.light),
          ),
          DropdownMenuItem(
            value: ThemeMode.system,
            child: Text(context.l10n.system),
          ),
        ],
        onChanged: (value) {
          if (value != null) {
            preferencesNotifier.setThemeMode(value);
          }
        },
      ),
      ListTile(
        leading: const Icon(SpotubeIcons.palette),
        title: Text(context.l10n.accent_color),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        trailing: ColorTile.compact(
          color: preferences.accentColorScheme,
          onPressed: pickColorScheme(),
          isActive: true,
        ),
        onTap: pickColorScheme(),
      ),
      // SwitchListTile(
      //   secondary: const Icon(SpotubeIcons.colorSync),
      //   title: Text(context.l10n.sync_album_color),
      //   subtitle: Text(context.l10n.sync_album_color_description),
      //   value: preferences.albumColorSync,
      //   onChanged: preferencesNotifier.setAlbumColorSync,
      // ),
    ];

    if (isGettingStarted) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final child in children) ...[
            child,
            const Gap(16),
          ],
        ],
      );
    }

    return SectionCardWithHeading(
      heading: context.l10n.appearance,
      children: children,
    );
  }
}
