import 'package:boiler_plater_flutter_v3/features/auth/auth_binding.dart';
import 'package:boiler_plater_flutter_v3/features/auth/presentation/pages/send_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/di/app_binding.dart';
import 'core/config/app_config.dart';
import 'core/locale/language_service.dart';
import 'l10n/app_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app binding
  await AppBinding.initialize();
  

  
  runApp( MyApp());
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
            // Show loading indicator while language service is initializing
            if (!languageService.isInitialized) {
              return MaterialApp(
                title: AppConfig.appName,
                home: const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                debugShowCheckedModeBanner: AppConfig.enableDebugMode,
              );
            }
            
            return MaterialApp(
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
              home: BlocProvider(
                create: (context) => AuthBinding.sendOtpBloc,
                child: const SendOtpPage(),
              ),
              debugShowCheckedModeBanner: AppConfig.enableDebugMode,
            );
          },
        );
      },
    );
  }
}
