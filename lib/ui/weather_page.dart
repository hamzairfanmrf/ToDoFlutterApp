import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoflutter/view_model/weatherViewModel.dart';

class WeatherDisplay extends StatefulWidget {
  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  @override
  Widget build(BuildContext context) {
    final weatherData = context.watch<WeatherViewModel>().weatherData;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          // Add a background image
          image: DecorationImage(
            image: AssetImage(_getBackgroundImage(weatherData?.weatherDescription)),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon and Temperature
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Weather Icon
                  Icon(
                    _getWeatherIcon(weatherData?.weatherDescription),
                    size: 40,
                    color: Colors.white,
                  ),
                  // Temperature
                  Text(
                    '${weatherData?.temperature.ceil()}°C',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Weather Description
              Text(
                'Weather',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                weatherData?.weatherDescription ?? 'N/A',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to determine the appropriate weather icon
  IconData _getWeatherIcon(String? weatherDescription) {

    if (weatherDescription == 'Clear') {
      return Icons.wb_sunny;
    } else if (weatherDescription == 'Clouds') {
      return Icons.cloud;
    } else {
      return Icons.wb_cloudy; // Default icon for other weather conditions
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
