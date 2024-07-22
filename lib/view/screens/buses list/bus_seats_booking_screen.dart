import 'package:bus_booking_app/models/buses_model.dart';
import 'package:bus_booking_app/router/router.dart';
import 'package:bus_booking_app/services/shared_preference_service.dart';
import 'package:bus_booking_app/utility/colors.dart';
import 'package:bus_booking_app/view/widgets/common/common_button_widget.dart';
import 'package:bus_booking_app/view/widgets/common/common_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../services/firebase_service.dart';
import '../../../utility/utils.dart';

class BusTicketBookScreen extends StatefulWidget {
  final Bus bus;
  const BusTicketBookScreen({super.key, required this.bus});

  @override
  State<BusTicketBookScreen> createState() => _BusTicketBookScreenState();
}

class _BusTicketBookScreenState extends State<BusTicketBookScreen> {
  List<int> _selectedIndex = [];
  bool _isLoading=false;
  @override
  void initState() {
    super.initState();
    _selectedIndex.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BrandColors.primary_accent,
      height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 165,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: BrandColors.secondary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: BrandColors.primary, width: 1)),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: (1 / 1.25)),
              shrinkWrap: true,
              itemCount: 30,
              itemBuilder: (context, listIndex) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      if (listIndex <= widget.bus.availableSeats && !_isLoading) {
                        if (_selectedIndex.contains(listIndex)) {
                          _selectedIndex.remove(listIndex);
                          setState(() {});
                        } else {
                          _selectedIndex.add(listIndex);
                          setState(() {});
                        }
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _selectedIndex.contains(listIndex)
                                    ? BrandColors.primary
                                    : BrandColors.shadow,
                                width: 1)),
                        padding: const EdgeInsets.all(10),
                        child: listIndex > widget.bus.availableSeats
                            ? const Icon(
                                CupertinoIcons.xmark_seal,
                                color: BrandColors.primary,
                                size: 25,
                              )
                            : CommonText(
                                text: (listIndex + 1).toString(),
                                color: _selectedIndex.contains(listIndex)
                                    ? BrandColors.primary
                                    : BrandColors.shadow,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                  ),
                );
              },
            ),
          ),
          Align(alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(color: BrandColors.secondary,boxShadow: [
                BoxShadow(
                    color: BrandColors.shadow, blurRadius: 10, spreadRadius: 3)
              ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CommonText(
                            text:
                                "\u20b9 ${Utils.formatNumber(widget.bus.fare * _selectedIndex.length)}",
                            color: BrandColors.text,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: CommonText(
                              text: "(Excluding Tax)",
                              color: BrandColors.shadow,
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      CommonText(
                        text: "For ${_selectedIndex.length} Seats",
                        color: BrandColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  SizedBox(width: 100,height: 100,child: CommonButton(onTap: () {
                    if(_selectedIndex.isNotEmpty){
                      _uploadTicketsData();
                    }
                  }, buttonText: "Buy",isEnabled: _selectedIndex.isNotEmpty,isLoading: _isLoading,))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _uploadTicketsData() async {
    _isLoading=true;
    setState(() {});
    var userId = await Preference.getUser();
    Map<String, dynamic> booked = ({});
    booked.addAll(widget.bus.toJson());
    booked.addAll({"booked": _selectedIndex.length});
    await FirebaseService.database
        .child('tickets')
        .child(userId!)
        .push()
        .set(booked).then((value){
          Utils.getSnackBar(context, "Tickets purchased successfully");
          AppRouter.pop(context);
        }).onError((error, stackTrace) {
          print(error.toString());
          Utils.getSnackBar(context, "Failed to buy tickets");
        });
  }
}
