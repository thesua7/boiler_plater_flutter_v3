import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/route/app_route.dart';
import 'core/theme/app_theme.dart';
import 'core/di/app_binding.dart';
import 'core/config/app_config.dart';
import 'core/locale/language_service.dart';

import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app binding
  await AppBinding.initialize();

  // Initialize language service and load saved language

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = AppBinding.themeService;
    final languageService = LanguageService();

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeService,
      builder: (context, themeMode, child) {
        return ListenableBuilder(
          listenable: languageService,
          builder: (context, child) {
            return MaterialApp.router(
              title: AppConfig.appName,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: LanguageService.supportedLocales,
              locale: languageService.currentLocale,
              routerConfig: appRoute,
              debugShowCheckedModeBanner: AppConfig.enableDebugMode,
            );
          },
        );
      },
    );
  }
}
