import 'package:dual_calendar/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/calendar_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = Provider.of<SettingsProvider>(context);
    return Consumer<CalendarProvider>(builder: (context, provider, child) {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                l10n.appTitle,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.language),
              trailing: DropdownButton<String>(
                value: settings.locale.languageCode,
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(l10n.english),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text(l10n.arabic),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    settings.setLocale(Locale(value));
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(l10n.theme),
              trailing: DropdownButton<ThemeMode>(
                value: settings.themeMode,
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(l10n.system),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(l10n.lightMode),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(l10n.darkMode),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    settings.setThemeMode(value);
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(l10n.gregorianCalendar),
              trailing: DropdownButton<ThemeMode>(
                value: settings.themeMode,
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(l10n.system),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(l10n.darkMode),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    settings.setThemeMode(value);
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
