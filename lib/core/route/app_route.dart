// Optimized GoRouter configuration with lazy BLoC creation
import 'package:boiler_plater_flutter_v3/examplePages/screenutil_demo_page.dart';
import 'package:boiler_plater_flutter_v3/examplePages/theme_test_page.dart';
import 'package:boiler_plater_flutter_v3/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_binding.dart';
import '../../features/auth/presentation/sendOtp/send_otp_page.dart';
import '../../features/auth/presentation/verifyOtp/verify_otp_page.dart';
import '../../features/splash/splash_binding.dart';
import '../../features/splash/splash_page.dart';
import 'custom_transition.dart';
import 'route_constant.dart';

final GoRouter appRoute = GoRouter(
  initialLocation: RouteConstant.splash,
  routes: [
    GoRoute(
      path: RouteConstant.splash,
      pageBuilder: (context, state) => AppTransitionWrapper.build(
        state: state,
        child: BlocProvider(
          create: (context) {
            // Initialize SplashBinding on-demand when this route is accessed
            if (!SplashBinding.isInitialized) {
              SplashBinding.initialize();
            }
            return SplashBinding.splashBloc;
          },
          child: const SplashPage(),
        ),
        // transition: AppTransition.fade, // optional override
      ),
    ),
    GoRoute(
      path: RouteConstant.sendOtp,
      pageBuilder: (context, state) => AppTransitionWrapper.build(
        state: state,
        child: BlocProvider(
          create: (context) {
            // Initialize AuthBinding on-demand when this route is accessed
            if (!AuthBinding.isInitialized) {
              AuthBinding.initialize();
            }
            return AuthBinding.sendOtpBloc;
          },
          child: const SendOtpPage(),
        ),
      ),
    ),
    GoRoute(
      path: RouteConstant.verifyOtp,
      pageBuilder: (context, state) => AppTransitionWrapper.build(
        state: state,
        child: BlocProvider(
          create: (context) {
            // Initialize AuthBinding on-demand when this route is accessed
            if (!AuthBinding.isInitialized) {
              AuthBinding.initialize();
            }
            return AuthBinding.verifyOtpBloc;
          },
          child: VerifyOtpPage(
            phoneNumber: state.uri.queryParameters['phone'] ?? '',
          ),
        ),
        // transition: AppTransition.bottomToTop, // optional override
      ),
    ),
    GoRoute(
      path: RouteConstant.home,
      pageBuilder: (context, state) => AppTransitionWrapper.build(
        state: state,
        child: HomePage(),
        // transition: AppTransition.scaleWithFade, // optional override
      ),
    ),

    GoRoute(
      path: RouteConstant.testTheme,
      pageBuilder: (context, state) => AppTransitionWrapper.build(
        state: state,
        child: ThemeTestPage(),
        // transition: AppTransition.scaleWithFade, // optional override
      ),
    ),
    GoRoute(
      path: RouteConstant.screenUtilDemo,
      pageBuilder: (context, state) => AppTransitionWrapper.build(
        state: state,
        child: const ScreenUtilDemoPage(),
        // transition: AppTransition.scaleWithFade, // optional override
      ),
    ),
  ],
);
