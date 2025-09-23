import 'package:boiler_plater_flutter_v3/features/auth/auth_binding.dart';
import 'package:boiler_plater_flutter_v3/features/auth/presentation/pages/send_otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/di/app_binding.dart';
import 'core/config/app_config.dart';


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

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeService,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: AppConfig.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          home: BlocProvider(
            create: (context) => AuthBinding.sendOtpBloc,
            child: const SendOtpPage(),
          ),
          debugShowCheckedModeBanner: AppConfig.enableDebugMode,
        );
      },
    );
  }
}
