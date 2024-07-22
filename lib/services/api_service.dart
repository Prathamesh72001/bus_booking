import 'dart:convert';

import 'package:bus_booking_app/models/buses_model.dart';
import 'package:bus_booking_app/utility/api_urls.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../utility/assets.dart';

class APIService {
  static Future<List<Bus>?> getBusList() async {
    final headers = {'API-KEY': 'ABC1234', 'Content-Type': 'application/json'};
    final body = json.encode({'bus_count': '4'});

    try {
      List<Bus> cityNames = [];
      // Load the JSON file
      String data = await rootBundle.loadString(Assets.buses);

      // Parse the JSON data
      var buses = json.decode(data)['buses'] as List<dynamic>;
      // Extract city names
      Bus.fromJsonList(buses).forEach((element) {
        cityNames.add(element);
      });
      return cityNames;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
