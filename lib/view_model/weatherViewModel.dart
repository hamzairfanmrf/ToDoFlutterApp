// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
//
// import '../model/weathermodel.dart';
// import 'package:geolocator/geolocator.dart';
//
// class WeatherViewModel extends ChangeNotifier {
//   WeatherModel? weatherData; // Variable to hold the WeatherModel data
//
//   // Define your API key and base URL here
//   final String apiKey = "7bd6500cd08d4264bd638b9ba6f40a4a";
//   final String baseUrl = "http://api.openweathermap.org/data/2.5/forecast";
//   Future<Position> determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition();
//   }
//   Future<void> fetchWeather(double lat, double lon) async {
//     final apiUrl =
//         'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl));
//
//       if (response.statusCode == 200) {
//         // Parse the JSON response
//         final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
//
//         // Initialize the WeatherModel with the response data
//         weatherData = WeatherModel.fromJson(jsonResponse);
//         print(weatherData!.temperature);
//
//         // Notify listeners about the change in state
//         notifyListeners();
//       } else {
//         // If the server did not return a 200 OK response, throw an exception
//         throw Exception('Failed to load weather data');
//       }
//     } catch (e) {
//       print("Exception: $e");
//     }
//   }
//
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/weathermodel.dart';
import 'package:geolocator/geolocator.dart';

class WeatherViewModel extends GetxController {
  Rx<WeatherModel?> weatherData = WeatherModel(temperature: 0, weatherDescription: '').obs;

  final String apiKey = "7bd6500cd08d4264bd638b9ba6f40a4a";

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<void> fetchWeather(double lat, double lon) async {
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        weatherData.value = WeatherModel.fromJson(jsonResponse);

        // print(weatherData.value!.weatherDescription);

      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
