class Meteo{
  String city;
  num temperature;

  Meteo({
    required this.city,
    required this.temperature,
  });

  factory Meteo.fromJson(Map<String, dynamic> json) => Meteo(
    city: json['name'],
    temperature: (json['main']['temp'] - 273.15).round(),
  );

  Map<String, dynamic> toJson() => {
    'city': city,
    'temperature': temperature
  };
}