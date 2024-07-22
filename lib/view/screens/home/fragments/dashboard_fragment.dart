import 'dart:convert';

import 'package:bus_booking_app/models/destination_model.dart';
import 'package:bus_booking_app/router/router.dart';
import 'package:bus_booking_app/utility/assets.dart';
import 'package:bus_booking_app/utility/colors.dart';
import 'package:bus_booking_app/utility/strings.dart';
import 'package:bus_booking_app/view/screens/buses%20list/busess_list_screen.dart';
import 'package:bus_booking_app/view/widgets/ad/ad.dart';
import 'package:bus_booking_app/view/widgets/ad/carousel_ad.dart';
import 'package:bus_booking_app/view/widgets/common/common_text_widget.dart';
import 'package:bus_booking_app/view/widgets/common/loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../widgets/common/common_button_widget.dart';

class DashboardFragment extends StatefulWidget {
  const DashboardFragment({super.key});

  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  List<String> cityNames = [];
  String? destination;
  String? departing;
  String? dateTime;
  bool isLoading = false;
  bool isScreenLoading = false;
  bool enableButton = false;
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      checkIfSearchEnabled();
    }
  }

  @override
  void initState() {
    loadDestinations();
    super.initState();
  }

  Future<void> loadDestinations() async {
    isScreenLoading = true;
    setState(() {});
    cityNames.clear();
    // Load the JSON file
    String data = await rootBundle.loadString(Assets.destinations);

    // Parse the JSON data
    var destinations = json.decode(data)['destinations'] as List<dynamic>;
    // Extract city names
    Destination.fromJsonList(destinations).forEach((element) {
      cityNames.add(element.name!);
    });
    isScreenLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      color: BrandColors.primary_accent,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: isScreenLoading
          ? const Center(child: LoaderWidget())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: CommonText(
                      text: Strings.bus_ticket,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: BrandColors.secondary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: BrandColors.secondary,
                          width: 2,
                        )),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.bus,
                              color: BrandColors.secondary,
                              size: 25,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CommonText(
                                    text: Strings.date_of_journey,
                                    color: BrandColors.secondary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    child: DropdownButton<String>(
                                      dropdownColor: BrandColors.primary_accent,
                                      isExpanded: true,
                                      icon: const Icon(
                                        CupertinoIcons.chevron_down_circle,
                                        size: 15,
                                        color: BrandColors.secondary,
                                      ),
                                      hint: const CommonText(
                                        text: Strings.selct_date_of_journey,
                                        color: BrandColors.secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      value: departing,
                                      menuMaxHeight: 300,
                                      underline: Container(
                                        height: 1,
                                        color: BrandColors.secondary,
                                      ),
                                      items: cityNames.map((city) {
                                        return DropdownMenuItem<String>(
                                          value: city,
                                          child: CommonText(
                                            text: city,
                                            color: BrandColors.secondary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          departing = value ?? "";
                                        });
                                        checkIfSearchEnabled();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.bus,
                                color: BrandColors.secondary,
                                size: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CommonText(
                                      text: Strings.from,
                                      color: BrandColors.secondary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      child: DropdownButton<String>(
                                        dropdownColor:
                                            BrandColors.primary_accent,
                                        isExpanded: true,
                                        icon: const Icon(
                                          CupertinoIcons.chevron_down_circle,
                                          size: 15,
                                          color: BrandColors.secondary,
                                        ),
                                        hint: const CommonText(
                                          text: Strings.selct_from,
                                          color: BrandColors.secondary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        menuMaxHeight: 300,
                                        value: destination,
                                        underline: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 1,
                                          color: BrandColors.secondary,
                                        ),
                                        items: cityNames.map((city) {
                                          return DropdownMenuItem<String>(
                                            value: city,
                                            child: CommonText(
                                              text: city,
                                              color: BrandColors.secondary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            destination = value ?? "";
                                          });
                                          checkIfSearchEnabled();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 35),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  CupertinoIcons.calendar,
                                  color: BrandColors.secondary,
                                  size: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: CommonText(
                                          text: Strings.date_of_journey,
                                          color: BrandColors.secondary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  CommonText(
                                                    text: selectedDate != null
                                                        ? DateFormat(
                                                                'EEE, dd MMM yyyy')
                                                            .format(
                                                                selectedDate!)
                                                        : Strings
                                                            .selct_date_of_journey,
                                                    color:
                                                        BrandColors.secondary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  const Icon(
                                                    CupertinoIcons
                                                        .chevron_down_circle,
                                                    size: 15,
                                                    color:
                                                        BrandColors.secondary,
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5),
                                                child: Container(
                                                  height: 1,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      150,
                                                  color: BrandColors.secondary,
                                                ),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        CommonButton(
                            isEnabled: enableButton,
                            onTap: () {
                              if (enableButton) {
                                isLoading = true;
                                setState(() {});
                                Future.delayed(const Duration(seconds: 2),
                                    () async {
                                  isLoading = false;
                                  setState(() {});
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BusListScreen(
                                        departing: departing!,
                                        destination: destination!,
                                        dateTime: selectedDate!,
                                      ),
                                    ),
                                  );
                                });
                              }
                            },
                            isLoading: isLoading,
                            buttonText: Strings.search_bus)
                      ],
                    ),
                  ),
                  const CarouselAd(),
                  const Ad(),
                  const SizedBox(
                    height: 75,
                  )
                ],
              ),
            ),
    );
  }

  checkIfSearchEnabled() {
    if (destination != null &&
        departing != null &&
        selectedDate != null &&
        destination != departing) {
      setState(() {
        enableButton = true;
      });
    } else {
      setState(() {
        enableButton = false;
      });
    }
  }
}
