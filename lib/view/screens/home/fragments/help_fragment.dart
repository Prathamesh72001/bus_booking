import 'dart:async';

import 'package:bus_booking_app/utility/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

import '../../../../utility/colors.dart';

class HelpFragment extends StatefulWidget {
  const HelpFragment({super.key});

  @override
  State<HelpFragment> createState() => _HelpFragmentState();
}

class _HelpFragmentState extends State<HelpFragment> {
  final _webViewKey = UniqueKey();
  late WebViewXController _webViewXController;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: BrandColors.primary_accent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : WebViewX(
                      width: MediaQuery.of(context).size.width,
                      height:
                          MediaQuery.of(context).size.height - kToolbarHeight,
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageStarted: (src) {
                      },
                      navigationDelegate: (navigation) {
                        return NavigationDecision.navigate;
                      },
                      onWebViewCreated: (controller) {
                        _webViewXController = controller;
                        controller.loadContent(
                          APIUrls.helpPageUrl,SourceType.urlBypass,
                        );
                      },
                    ),
            
    );
  }
}