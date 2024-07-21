import 'package:flutter/material.dart';

import '../../../../utility/colors.dart';

class MyBookingsFragment extends StatefulWidget {
  const MyBookingsFragment({super.key});

  @override
  State<MyBookingsFragment> createState() => _MyBookingsFragmentState();
}

class _MyBookingsFragmentState extends State<MyBookingsFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: BrandColors.primary_accent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }
}