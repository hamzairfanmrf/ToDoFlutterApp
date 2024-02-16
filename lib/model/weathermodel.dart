// class WeatherModel {
//   double temp;
//   double feelsLike;
//   double tempMin;
//   double tempMax;
//   int pressure;
//   int seaLevel;
//   int grndLevel;
//   int humidity;
//   double tempKf;
//
//   WeatherModel({
//     required this.temp,
//     required this.feelsLike,
//     required this.tempMin,
//     required this.tempMax,
//     required this.pressure,
//     required this.seaLevel,
//     required this.grndLevel,
//     required this.humidity,
//     required this.tempKf,
//   });
//
//   factory WeatherModel.fromJson(Map<String, dynamic> json) {
//     return WeatherModel(
//       temp: json['temp'].toDouble(),
//       feelsLike: json['feels_like'].toDouble(),
//       tempMin: json['temp_min'].toDouble(),
//       tempMax: json['temp_max'].toDouble(),
//       pressure: json['pressure'],
//       seaLevel: json['sea_level'],
//       grndLevel: json['grnd_level'],
//       humidity: json['humidity'],
//       tempKf: json['temp_kf'].toDouble(),
//     );
//   }
//
//   @override
//   String toString() {
//     return 'Temperature: $temp K, Feels Like: $feelsLike K, Min Temperature: $tempMin K, Max Temperature: $tempMax K, Pressure: $pressure hPa, Sea Level: $seaLevel hPa, Ground Level: $grndLevel hPa, Humidity: $humidity%, Temperature KF: $tempKf';
//   }
// }



class WeatherModel {
  final double temperature;
  final String weatherDescription;

  WeatherModel({
    required this.temperature,
    required this.weatherDescription,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['main']['temp'].toDouble(),
      weatherDescription: json['weather'][0]['description'],
    );
  }
}
