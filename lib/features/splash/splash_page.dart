import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/route/route_constant.dart';
import '../../core/responsive/responsive_utils.dart';
import 'bloc/splash_bloc.dart';
import 'bloc/splash_event.dart';
import 'bloc/splash_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<SplashBloc>().add(const CheckAuthenticationStatus());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashAuthenticated) {
            context.go(RouteConstant.home);
          } else if (state is SplashUnauthenticated || state is SplashError) {
            context.go(RouteConstant.sendOtp);
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary.withOpacity(0.9),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    ScaleTransition(
                      scale: _animation,
                      child: Container(
                        width: ResponsiveUtils.getResponsiveWidth(context, 120),
                        height: ResponsiveUtils.getResponsiveWidth(context, 120),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.flutter_dash,
                          size: ResponsiveUtils.getResponsiveFontSize(context, 64),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveHeight(context, 24)),

                    // App Name
                    FadeTransition(
                      opacity: _animation,
                      child: Text(
                        'Boiler Plate',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveHeight(context, 8)),

                    // Subtitle
                    FadeTransition(
                      opacity: _animation,
                      child: Text(
                        'Flutter V3',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveUtils.getResponsiveHeight(context, 40)),

                    // Simple Loading Indicator
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
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
