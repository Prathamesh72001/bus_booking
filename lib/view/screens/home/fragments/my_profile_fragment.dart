import 'package:flutter/material.dart';

import '../../../../utility/colors.dart';

class MyProfileFragment extends StatefulWidget {
  const MyProfileFragment({super.key});

  @override
  State<MyProfileFragment> createState() => _MyProfileFragmentState();
}

class _MyProfileFragmentState extends State<MyProfileFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: BrandColors.primary_accent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }
}