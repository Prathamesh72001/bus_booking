import 'package:flutter/material.dart';

import '../../../../utility/colors.dart';

class HelpFragment extends StatefulWidget {
  const HelpFragment({super.key});

  @override
  State<HelpFragment> createState() => _HelpFragmentState();
}

class _HelpFragmentState extends State<HelpFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: BrandColors.primary_accent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }
}