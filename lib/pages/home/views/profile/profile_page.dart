import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_template/app/bloc/locale_bloc.dart';
import 'package:my_flutter_template/app/bloc/theme_bloc.dart';
import 'package:my_flutter_template/l10n/app_localizations.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => _showLogoutDialog(context, l10n),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Foydalanuvchi Profili Kartasi (User Info Header)
            _buildUserCard(theme),
            const SizedBox(height: 24),

            // 2. Ilova Sozlamalari bo'limi (Settings Section)
            _buildSectionTitle(theme, "Ilova sozlamalari"),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  // Tungi rejim tanaffusi (Theme Switch)
                  SwitchListTile(
                    secondary: Icon(Icons.dark_mode_rounded, color: theme.colorScheme.primary),
                    title: const Text("Tungi rejim (Dark Mode)"),
                    value: isDark,
                    onChanged: (bool value) {
                      context.read<ThemeBloc>().add(ToggleThemeEvent(value));
                    },
                  ),
                  const Divider(height: 1, indent: 56),

                  // Tilni o'zgartirish bloki (Language Dropdown)
                  ListTile(
                    leading: Icon(Icons.language_rounded, color: theme.colorScheme.primary),
                    title: Text(l10n.changeLanguage),
                    trailing: DropdownButton<String>(
                      value: Localizations.localeOf(context).languageCode,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down_rounded),
                      items: const [
                        DropdownMenuItem(value: 'uz', child: Text("O'zbekcha")),
                        DropdownMenuItem(value: 'ru', child: Text("Русский")),
                        DropdownMenuItem(value: 'en', child: Text("English")),
                      ],
                      onChanged: (String? newLanguageCode) {
                        if (newLanguageCode != null) {
                          context.read<LocaleBloc>().add(ChangeLocaleEvent(newLanguageCode));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Qo'shimcha Menyular (Xavfsizlik, Yordam va h.k.)
            _buildSectionTitle(theme, "Qo'shimcha"),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.shield_rounded,
                    title: "Xavfsizlik qoidalari",
                    theme: theme,
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildSettingsTile(
                    icon: Icons.help_outline_rounded,
                    title: "Yordam markazi",
                    theme: theme,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Foydalanuvchi ma'lumotlari vizual qismi
  Widget _buildUserCard(ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.primary.withOpacity(0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                "SA", // Ism va familiya bosh harflari (Masalan: Sunnatillo Abdukhakimov)
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sunnatillo",
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Dasturchi / Asoschi",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit_square, color: theme.colorScheme.primary),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  // Bo'lim sarlavhasi
  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  // Universal ListTile generatori
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.7)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: onTap,
    );
  }

  // Tizimdan chiqish dialogi (Logout Confirmation)
  void _showLogoutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.logout),
          content: Text(l10n.logoutConfirmation),
          actions: [
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(l10n.logout, style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                Navigator.of(context).pop();
                // Bu yerga chiqish logikasi yoziladi
              },
            ),
          ],
        );
      },
    );
  }
}