import 'package:bus_booking_app/router/router.dart';
import 'package:bus_booking_app/services/api_service.dart';
import 'package:bus_booking_app/utility/colors.dart';
import 'package:bus_booking_app/view/screens/buses%20list/bus_seats_booking_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/buses_model.dart';
import '../../widgets/common/common_text_widget.dart';
import '../../widgets/common/loader_widget.dart';

class BusListScreen extends StatefulWidget {
  final String destination;
  final String departing;
  final DateTime dateTime;
  const BusListScreen({
    super.key,
    required this.destination,
    required this.departing,
    required this.dateTime,
  });

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  bool isLoading = true;
  List<Bus> busList = [];

  @override
  void initState() {
    super.initState();
    getBusList();
  }

  void getBusList() async {
    busList.clear();
    await APIService.getBusList().then((value) {
      if (value != null) {
        busList.addAll(value);
      }
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: BrandColors.primary_accent,
          leading: IconButton(
              onPressed: () => AppRouter.pop(context),
              icon: const Icon(
                CupertinoIcons.chevron_back,
                color: BrandColors.secondary,
                size: 20,
              )),
          centerTitle: true,
          title: SizedBox(
            width: MediaQuery.of(context).size.width * .85,
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(
                  text: "${widget.departing} - ${widget.destination}",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: BrandColors.secondary,
                ),
                CommonText(
                  text: DateFormat('EEE, dd MMM').format(widget.dateTime),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: BrandColors.secondary,
                ),
              ],
            ),
          ),
        ),
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusTicketBookScreen(
                                bus: busList[index],
                              ),
                            ),
                          );
                        },
                        child: Container(
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
                                          text: busList[index]
                                              .route
                                              .split("to")[0],
                                          color: BrandColors.secondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
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
                                          text: busList[index]
                                              .route
                                              .split("to")[1],
                                          color: BrandColors.secondary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  CommonText(
                                    text:
                                        "Available Seats : ${busList[index].availableSeats}",
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
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  )));
  }
}
