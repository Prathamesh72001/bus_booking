import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import '../../../utility/colors.dart';
import '../../../utility/utils.dart';

class CarouselAd extends StatefulWidget {
  const CarouselAd({super.key});

  @override
  State<CarouselAd> createState() => _CarouselAdState();
}

class _CarouselAdState extends State<CarouselAd> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Column(
        children: [
          CarouselSlider(
            carouselController: _controller,
            items: [
              GestureDetector(
                  onDoubleTap: () =>
                      Utils.launchURL("https://www.grabon.in/redbus-coupons/"),
                  onTap: () =>
                      Utils.launchURL("https://www.grabon.in/redbus-coupons/"),
                  child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width),
                      child: Image.network(
                        "https://cdn.grabon.in/gograbon/images/merchant/1689592552370.jpg",
                        fit: BoxFit.fill,
                      ))),
              GestureDetector(
                  onTap: () =>
                      Utils.launchURL("https://www.grabon.in/redbus-coupons/"),
                  child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width),
                      child: Image.network(
                        "https://cdn.grabon.in/gograbon/images/web-images/uploads/1618579554027/redbus-coupons.jpg",
                        fit: BoxFit.fill,
                      ))),
            ],
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * .25,
              viewportFraction: 1,
              autoPlay: true,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {},
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [0, 1].map((entry) {
              return GestureDetector(
                onTap: () {
                  _controller.animateToPage(entry);
                },
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: BrandColors.primary
                          .withOpacity(_current == entry ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
