class Position {
  String country;
  num latitude;
  num longitude;

  Position({
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    country: json['country'],
    latitude: json['latitude'],
    longitude: json['longitude'],
  );

  Map<String, dynamic> toJson() => {
    'country': country,
    'latitude': latitude,
    'longitude': longitude,
  };
}