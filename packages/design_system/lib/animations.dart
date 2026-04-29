import 'package:flutter/material.dart';

class AppAnimations {
  AppAnimations._();

  static const Duration micro = Duration(milliseconds: 200);
  static const Duration fast = Duration(milliseconds: 400);
  static const Duration normal = Duration(milliseconds: 600);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration dramatic = Duration(milliseconds: 1200);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve spring = Curves.elasticOut;
  static const Curve smooth = Curves.easeInOutCubic;

  static const Duration staggerDelay = Duration(milliseconds: 50);

  static Route<T> fadeRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: normal,
    );
  }

  static Route<T> slideUpRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0, 0.15), end: Offset.zero)
            .chain(CurveTween(curve: enter));
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: normal,
    );
  }
}
