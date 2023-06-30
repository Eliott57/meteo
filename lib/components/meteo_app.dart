import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/meteo.dart';
import '../models/position.dart';

class MeteoApp extends StatefulWidget {
  const MeteoApp({super.key});

  @override
  State<MeteoApp> createState() => _MeteoAppState();
}

class _MeteoAppState extends State<MeteoApp> {
  final TextEditingController _cityController = TextEditingController();
  Meteo? _currentMeteo;
  String _currentCountry = '';

  void printMeteo({required String city}) async {
    final Position gpsPosition = await getGPSPosition(city: city);
    final Meteo meteo = await getMeteo(gpsPosition: gpsPosition);

    setState(() {
      _currentMeteo = meteo;
      _currentCountry = gpsPosition.country;
    });
  }

  Future<Position> getGPSPosition({required String city}) async {
    try {
      final dio = Dio();

      dio.options.headers['X-Api-Key'] = dotenv.env['CITY_API_KEY'];

      final response = await dio.get(
          'https://api.api-ninjas.com/v1/city',
          queryParameters: {
            'name': city
          }
      );

      return Position.fromJson((response.data as List)[0]);
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  Future<Meteo> getMeteo({required Position gpsPosition}) async {
    try {
      final dio = Dio();

      String url = 'https://api.openweathermap.org/data/2.5/weather?lat=${gpsPosition.latitude}&lon=${gpsPosition.longitude}&appid=${dotenv.env['METEO_API_KEY']}';

      final response = await dio.get(url);

      return Meteo.fromJson(response.data);
    } catch (error, stacktrace) {
      throw Exception("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Meteo app'),
      ),
      body: Center(
        child:
          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  hintText: 'City name',
                  labelText: 'City name *',
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                printMeteo(city: _cityController.text);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Text(_currentMeteo?.city ?? 'Valider'),
              ),
            ),
            if(_currentMeteo != null)
              Text(
                  'City : ${_currentMeteo?.city}, Country : $_currentCountry, Temperature : ${_currentMeteo?.temperature}°C'
              ),
          ],
        ),
      ),
    );
  }
}
