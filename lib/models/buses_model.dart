class Bus {
  final String id;
  final String busName;
  final String route;
  final String departureTime;
  final String arrivalTime;
  final int fare;
  final int availableSeats;
  final int? bookedSeats;

  Bus({
    required this.id,
    required this.busName,
    required this.route,
    required this.departureTime,
    required this.arrivalTime,
    required this.fare,
    required this.availableSeats,
    this.bookedSeats=0,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['id'],
      busName: json['busName'],
      route: json['route'],
      departureTime: json['departureTime'],
      arrivalTime: json['arrivalTime'],
      fare: json['fare'],
      availableSeats: json['availableSeats'],
      bookedSeats: json['booked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'busName': busName,
      'route': route,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'fare': fare,
      'availableSeats': availableSeats,
    };
  }

  // From JSON list
  static List<Bus> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Bus.fromJson(json)).toList();
  }

  // To JSON list
  static List<Map<String, dynamic>> toJsonList(List<Bus> buses) {
    return buses.map((bus) => bus.toJson()).toList();
  }
}