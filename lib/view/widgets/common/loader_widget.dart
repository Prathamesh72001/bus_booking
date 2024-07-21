import 'package:bus_booking_app/utility/colors.dart';
import 'package:flutter/material.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(color: BrandColors.primary,);
  }
}