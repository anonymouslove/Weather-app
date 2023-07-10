import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class WeatherForecast {
  final int hour;
  final double temperature;
  final String condition;
  final String weatherIcon;


  WeatherForecast({required this.hour, required this.temperature, required this.condition,required this.weatherIcon,});
}

class WeatherApiService {
  static const apiKey = '2caef2b14d634e6a9de221117230207'; // Replace with your weatherapi.com API key

  static Future<List<WeatherForecast>> getHourlyForecasts(double latitude, double longitude) async {
    final url = 'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$latitude,$longitude&days=1&aqi=no&alerts=no';

    final response = await http.get(Uri.parse(url));
    final jsonData = json.decode(response.body);

    final hourlyData = jsonData['forecast']['forecastday'][0]['hour'];

    final hourlyForecasts = hourlyData.map<WeatherForecast>((hourData) {
      final hour = DateTime.parse(hourData['time']).hour;
      final temperature = hourData['temp_c'];
      final condition = hourData['condition']['text'];
      final weatherIcon= hourData['condition']['icon'];
      return WeatherForecast(hour: hour, temperature: temperature, condition: condition, weatherIcon: weatherIcon);
    }).toList();

    return hourlyForecasts;
  }
}

class HourlyForecastScreen extends StatefulWidget {
  @override
  _HourlyForecastScreenState createState() => _HourlyForecastScreenState();
}

class _HourlyForecastScreenState extends State<HourlyForecastScreen> {
  List<WeatherForecast> forecasts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchHourlyForecasts();
  }

  Future<void> fetchHourlyForecasts() async {
    setState(() {
      isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final latitude = position.latitude;
      final longitude = position.longitude;

      final hourlyForecasts = await WeatherApiService.getHourlyForecasts(latitude, longitude);

      setState(() {
        forecasts = hourlyForecasts;
      });
    } catch (e) {
      print('Error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentHour = DateTime.now().hour;

    return Scaffold(
      backgroundColor:  Color(0xff081b25),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: forecasts.length,
              itemBuilder: (context, index) {
                final forecast = forecasts[index];
                final hourFormatted = DateFormat('HH:mm').format(DateTime.now().add(Duration(hours: forecast.hour)));
                final isCurrentHour = forecast.hour == currentHour;
                 final isFirstContainer = index == 0;
            
               return SizedBox(
        width: 110.0, // Adjust the width according to your needs
        height:50.0,
               child: Container(
                  width: 120,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: isFirstContainer ?   LinearGradient(colors:[ 
            Colors.purple,
            Color.fromARGB(255, 21, 93, 201)
            ],)
           
            : (!isCurrentHour ?  LinearGradient(colors:[ 
            Colors.transparent,
            Color.fromARGB(255, 21, 93, 201)
            ], )
           
          :null ),
                  border: Border.all(
                 color: Colors.white,
                 width: 2.0,
        ),
          
                  ),
                  child:Column(children: [ 
                    //Text('20°C', style:TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                     Text('${forecast.temperature.toStringAsFixed(1)}°C', style:TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                     Text('${forecast.temperature.toStringAsFixed(1)}, ${forecast.condition}'),
                   // Image.asset('113.png'),
                     Image.network('https:${forecast.weatherIcon}'),
                              Text(hourFormatted,style:TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                  ]
                  ),
                ));
              },
            ),
    );
  }
}
