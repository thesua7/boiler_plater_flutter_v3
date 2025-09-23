import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../locale/language_service.dart';

/// Language Switcher Widget
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = Localizations.localeOf(context);
    final languageService = LanguageService();
    
    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: 'Change Language',
      onSelected: (Locale locale) async {
        await languageService.changeLanguage(locale);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Language changed to ${locale.languageCode}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Locale>(
          value: const Locale('en', ''),
          child: Row(
            children: [
              const Icon(Icons.flag, color: Colors.blue),
              const SizedBox(width: 8),
              Text(currentLocale.languageCode == 'en' ? 'English ✓' : 'English'),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('bn', ''),
          child: Row(
            children: [
              const Icon(Icons.flag, color: Colors.green),
              const SizedBox(width: 8),
              Text(currentLocale.languageCode == 'bn' ? 'বাংলা ✓' : 'বাংলা'),
            ],
          ),
        ),
      ],
    );
  }
}
