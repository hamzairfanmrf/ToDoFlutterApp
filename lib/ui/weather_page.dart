import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoflutter/view_model/weatherViewModel.dart';

class WeatherDisplay extends StatefulWidget {
  const WeatherDisplay({super.key});

  @override
  State<WeatherDisplay> createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  final controller = Get.put(WeatherViewModel());
  @override
  Widget build(BuildContext context) {
    print("wwwww is ${controller.weatherData.value!.weatherDescription}");
    return Container();

    //   GetBuilder<WeatherViewModel>(
    //
    //   builder: (weatherController) {
    //     // Access the value using .value and handle null
    //     final weatherData = weatherController.weatherData.value;
    //
    //     return weatherData!.weatherDescription.isNotEmpty?Card(
    //       elevation: 4,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           image: DecorationImage(
    //             image: AssetImage(_getBackgroundImage(weatherData?.weatherDescription)),
    //             fit: BoxFit.cover,
    //           ),
    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         child: Padding(
    //           padding: EdgeInsets.all(16),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Icon(
    //                     _getWeatherIcon(weatherData?.weatherDescription),
    //                     size: 40,
    //                     color: Colors.white,
    //                   ),
    //                   Text(
    //                     '${weatherData?.temperature?.ceil()}°C',
    //                     style: TextStyle(
    //                       fontSize: 24,
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.white,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(height: 16),
    //               Text(
    //                 'Weather',
    //                 style: TextStyle(
    //                   fontSize: 20,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //               SizedBox(height: 8),
    //               Text(
    //                 weatherData?.weatherDescription ?? 'N/A',
    //                 style: TextStyle(
    //                   fontSize: 18,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ):CircularProgressIndicator();
    //   },
    // );
  }

  IconData _getWeatherIcon(String? weatherDescription) {
    if (weatherDescription == 'Clear') {
      return Icons.wb_sunny;
    } else if (weatherDescription == 'Clouds') {
      return Icons.cloud;
    } else {
      return Icons.wb_cloudy;
    }
  }

  String _getBackgroundImage(String? weatherDescription) {
    if (weatherDescription == 'Clear') {
      return 'assets/clear_sky.jpg';
    } else if (weatherDescription == 'Clouds') {
      return 'assets/cloudy_sky.jpg';
    } else {
      return 'assets/clear_sky.jpg';
    }
  }
}
