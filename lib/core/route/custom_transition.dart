
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
  rightToLeftWithFade, scaleWithFade,
}

class AppTransitionWrapper<T> {
  static AppTransition defaultTransition = AppTransition.rightToLeftWithFade;

  /// Wrapper to use in all GoRoute pageBuilders
  static CustomTransitionPage<T> build<T>({
    required GoRouterState state,
    required Widget child,
    AppTransition? transition,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeInOut,
  }) {
    final effectiveTransition = transition ?? defaultTransition;

    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final anim = CurvedAnimation(parent: animation, curve: curve);

        switch (effectiveTransition) {
          case AppTransition.rightToLeft:
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(anim),
              child: child,
            );
          case AppTransition.leftToRight:
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero).animate(anim),
              child: child,
            );
          case AppTransition.bottomToTop:
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(anim),
              child: child,
            );
          case AppTransition.topToBottom:
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(anim),
              child: child,
            );
          case AppTransition.fade:
            return FadeTransition(opacity: anim, child: child);
          case AppTransition.scale:
            return ScaleTransition(scale: anim, child: child);
          case AppTransition.rotate:
            return RotationTransition(turns: anim, child: child);
          case AppTransition.size:
            return Align(
              alignment: Alignment.center,
              child: SizeTransition(sizeFactor: anim, child: child),
            );
          case AppTransition.rightToLeftWithFade:
            return FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(anim),
                child: child,
              ),
            );
          case AppTransition.scaleWithFade:
            return FadeTransition(
              opacity: anim,
              child: ScaleTransition(scale: anim, child: child),
            );
        }
      },
    );
  }
}
