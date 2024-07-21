import 'dart:convert';

import 'package:bus_booking_app/models/destination_model.dart';
import 'package:bus_booking_app/utility/assets.dart';
import 'package:bus_booking_app/utility/colors.dart';
import 'package:bus_booking_app/utility/strings.dart';
import 'package:bus_booking_app/view/widgets/common/common_text_widget.dart';
import 'package:bus_booking_app/view/widgets/common/loader_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/common/common_button_widget.dart';

class DashboardFragment extends StatefulWidget {
  const DashboardFragment({super.key});

  @override
  State<DashboardFragment> createState() => _DashboardFragmentState();
}

class _DashboardFragmentState extends State<DashboardFragment> {
  List<String> cityNames = [];
  String destination = "";
  String departing = "";
  bool isLoading = false;
  bool isScreenLoading = false;
  bool enableButton = false;

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

    departing = cityNames[0];
    destination = cityNames[1];
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
          : Column(
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
                                  text: Strings.to,
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
                                      text: Strings.selct_to,
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
                        padding: const EdgeInsets.only(top: 15, bottom: 35),
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
                      CommonButton(
                          isEnabled: enableButton,
                          onTap: () {
                            if (enableButton) {
                              isLoading = true;
                              setState(() {});
                            }
                          },
                          isLoading: isLoading,
                          buttonText: Strings.search_bus)
                    ],
                  ),
                )
              ],
            ),
    );
  }

  checkIfSearchEnabled() {
    if (destination != "" && departing != "") {
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
