import 'package:bus_booking_app/services/firebase_service.dart';
import 'package:bus_booking_app/services/shared_preference_service.dart';
import 'package:flutter/material.dart';

import '../../../../models/buses_model.dart';
import '../../../../utility/colors.dart';
import '../../../widgets/common/common_text_widget.dart';
import '../../../widgets/common/loader_widget.dart';

class MyBookingsFragment extends StatefulWidget {
  const MyBookingsFragment({super.key});

  @override
  State<MyBookingsFragment> createState() => _MyBookingsFragmentState();
}

class _MyBookingsFragmentState extends State<MyBookingsFragment> {
  bool isLoading = true;
  List<Bus> busList = [];

  @override
  void initState() {
    super.initState();
    getBusList();
  }

  void getBusList() async {
    busList.clear();
    var userID = await Preference.getUser();
    await FirebaseService.database
        .child("tickets")
        .child(userID!)
        .get()
        .then((value) {
      if (value.children.isNotEmpty) {
        for (var snapshot in value.children) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;
          var bus = Bus.fromJson(Map<String, dynamic>.from(values));
          busList.add(bus);
        }
      }
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(25),
            color: BrandColors.secondary,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: isLoading
                ? const Center(child: LoaderWidget())
                : ListView.builder(
                    itemCount: busList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            color: BrandColors.primary_accent,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                  color: BrandColors.shadow)
                            ]),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonText(
                              text: busList[index].busName,
                              color: BrandColors.secondary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      CommonText(
                                        text:
                                            busList[index].route.split("to")[0],
                                        color: BrandColors.secondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: CommonText(
                                          text: busList[index].departureTime,
                                          color: BrandColors.secondary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const CommonText(
                                    text: "----------",
                                    color: BrandColors.secondary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Column(
                                    children: [
                                      CommonText(
                                        text:
                                            busList[index].route.split("to")[1],
                                        color: BrandColors.secondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: CommonText(
                                          text: busList[index].arrivalTime,
                                          color: BrandColors.secondary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonText(
                                  text:
                                      "Booked Seats : ${busList[index].bookedSeats}",
                                  color: BrandColors.secondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                CommonText(
                                    text: "Fare : ${busList[index].fare}/ Each",
                                    color: BrandColors.secondary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )));
  }
}
