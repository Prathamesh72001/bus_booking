import 'package:bus_booking_app/router/router.dart';
import 'package:bus_booking_app/services/shared_preference_service.dart';
import 'package:bus_booking_app/utility/colors.dart';
import 'package:bus_booking_app/utility/strings.dart';
import 'package:bus_booking_app/view/screens/splash/splash_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'view/screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: Strings.app_name,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: BrandColors.primary),
          useMaterial3: false,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRouter.splashScreen,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }

  void init() async {
    await Preference.init();
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.debug);
  }
}
