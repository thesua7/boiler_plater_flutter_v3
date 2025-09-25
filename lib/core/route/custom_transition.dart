import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppTransition {
  rightToLeft,
  leftToRight,
  bottomToTop,
  topToBottom,
  fade,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  scaleWithFade,
}

class AppTransitionWrapper<T> {
  static AppTransition defaultTransition = AppTransition.leftToRight;

  /// Wrapper to use in all GoRoute pageBuilders
  static CustomTransitionPage<T> build<T>({
    required GoRouterState state,
    required Widget child,
    AppTransition? transition,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
  }) {
    final effectiveTransition = transition ?? defaultTransition;

    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

        switch (effectiveTransition) {
          case AppTransition.rightToLeft:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

          case AppTransition.leftToRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

          case AppTransition.bottomToTop:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

          case AppTransition.topToBottom:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, -1.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: child,
            );

          case AppTransition.fade:
            return FadeTransition(opacity: curvedAnimation, child: child);

          case AppTransition.scale:
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
              child: FadeTransition(opacity: curvedAnimation, child: child),
            );

          case AppTransition.rotate:
            return RotationTransition(
              turns: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
              child: child,
            );

          case AppTransition.size:
            return Align(
              alignment: Alignment.center,
              child: SizeTransition(
                sizeFactor: curvedAnimation,
                child: child,
              ),
            );

          case AppTransition.rightToLeftWithFade:
            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.3, 0.0),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );

          case AppTransition.scaleWithFade:
            return FadeTransition(
              opacity: curvedAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(curvedAnimation),
                child: child,
              ),
            );
        }
      },
    );
  }
}