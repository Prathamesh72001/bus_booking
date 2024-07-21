import 'package:bus_booking_app/view/screens/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../view/screens/home/home_screen.dart';
import '../view/screens/splash/splash_screen.dart';

class AppRouter {
  static const String splashScreen = '/';
  static const String homeScreen = '/home';
  static const String loginScreen = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case homeScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              transitionAnimation(
                  context, animation, secondaryAnimation, child),
        );
      case loginScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              transitionAnimation(
                  context, animation, secondaryAnimation, child),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }

  static Future<void> navigateTo(BuildContext context, String routeName) {
    return Navigator.pushNamed(context, routeName);
  }

  static Future<void> replaceWith(BuildContext context, String routeName) {
    return Navigator.pushReplacementNamed(context, routeName);
  }

  static SlideTransition transitionAnimation(
      context, animation, secondaryAnimation, child) {
    const begin = Offset(1.0, 0.0); // Start from right
      const end = Offset.zero; // End at the center
      const curve = Curves.easeInOut; // Smooth curve

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
  }
}
