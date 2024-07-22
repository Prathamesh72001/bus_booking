import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

import '../../../utility/colors.dart';
import '../../../utility/utils.dart';

class Ad extends StatefulWidget {
  const Ad({super.key});

  @override
  State<Ad> createState() => _AdState();
}

class _AdState extends State<Ad> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .25,
        child: GestureDetector(
            onDoubleTap: () =>
                Utils.launchURL("https://www.grabon.in/redbus-coupons/"),
            onTap: () =>
                Utils.launchURL("https://www.grabon.in/redbus-coupons/"),
            child: Container(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: Image.network(
                  "https://cdn.grabon.in/gograbon/images/merchant/1689592552370.jpg",
                  fit: BoxFit.fill,
                ))),
      ),
    );
  }
}
