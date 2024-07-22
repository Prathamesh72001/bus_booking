import 'package:bus_booking_app/services/shared_preference_service.dart';
import 'package:bus_booking_app/utility/assets.dart';
import 'package:bus_booking_app/utility/colors.dart';
import 'package:bus_booking_app/utility/strings.dart';
import 'package:bus_booking_app/view/widgets/common/common_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../router/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkForNavigation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(image: AssetImage(Assets.app_icon),height: 200, width: 200,),  // Replace with your app icon
                
            const CommonText(
                text: Strings.app_name,
                color: BrandColors.primary,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
                fontSize: 30)
          ],
        ),
      ),
    );
  }

  void checkForNavigation() async {
    bool? isLoggedIn = await Preference.getLoginStatus();
    Future.delayed(const Duration(seconds: 5), () async {
      if (isLoggedIn ?? false) {
        AppRouter.replaceWith(context, AppRouter.homeScreen);
      }else{
        AppRouter.replaceWith(context, AppRouter.loginScreen);
      }
    });
  }
}
