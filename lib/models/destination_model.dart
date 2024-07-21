class Destination {
  final int? id;
  final String? name;
  final String? state;
  final double? latitude;
  final double? longitude;

  Destination({
    this.id,
    this.name,
    this.state,
    this.latitude,
    this.longitude,
  });

  // From JSON
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // From JSON list
  static List<Destination> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Destination.fromJson(json)).toList();
  }

  // To JSON list
  static List<Map<String, dynamic>> toJsonList(List<Destination> destinations) {
    return destinations.map((destination) => destination.toJson()).toList();
  }
}
