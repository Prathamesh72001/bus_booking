import 'package:bus_booking_app/utility/assets.dart';
import 'package:bus_booking_app/utility/strings.dart';
import 'package:bus_booking_app/view/screens/home/fragments/dashboard_fragment.dart';
import 'package:bus_booking_app/view/screens/home/fragments/help_fragment.dart';
import 'package:bus_booking_app/view/screens/home/fragments/my_bookings_fragment.dart';
import 'package:bus_booking_app/view/screens/home/fragments/my_profile_fragment.dart';
import 'package:bus_booking_app/view/widgets/common/common_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utility/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List _children = [
    const DashboardFragment(),
    const MyBookingsFragment(),
    const HelpFragment(),
    const MyProfileFragment()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _children[_currentIndex],
      bottomNavigationBar: Container(
        height: kBottomNavigationBarHeight+5,
        margin: const EdgeInsets.all(25),
        child: ClipRRect(borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 50, // to get rid of the shadow
              currentIndex: _currentIndex,
              selectedItemColor: BrandColors.primary,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              backgroundColor: BrandColors
                  .secondary, // transparent, you could use 0x44aaaaff to make it slightly less transparent with a blue hue.
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.grey,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.home,
                      size: 20,
                    ),
                    label: 'Home',
                    backgroundColor: BrandColors.secondary),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.square_list,
                    size: 20,
                  ),
                  label: 'My Bookings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.question_diamond,
                    size: 20,
                  ),
                  label: 'Help',
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.profile_circled,
                      size: 20,
                    ),
                    label: 'My Account',
                    backgroundColor: BrandColors.secondary),
              ]),
        ),
      ),
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Image(image: AssetImage(Assets.app_icon),height: 75, width: 75,),  // Replace with your app icon
              const CommonText(
                text:Strings.app_name,
                fontWeight: FontWeight.bold,
                color: BrandColors.primary,
              ),
            ],
          ),
    ));
  }
}
