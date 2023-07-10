import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/mainscreen.dart';
class DailyForecast {
  final String dayOfWeek;
  final double maxTemperature;
final String conditionText;
  final String conditionIcon;

  DailyForecast({
    required this.dayOfWeek,
    required this.maxTemperature,
    required this.conditionText,
    required this.conditionIcon,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
        final date = DateTime.parse(json['date']);
    final dayOfWeek = DateFormat.E().format(date);

    return DailyForecast(
     dayOfWeek: dayOfWeek,
      maxTemperature: json['day']['maxtemp_c'].toDouble(),
conditionText: json['day']['condition']['text'],
      conditionIcon: json['day']['condition']['icon'],
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
 final String apiKey = '2caef2b14d634e6a9de221117230207';
DailyForecast? nextDayWeather;
  List<DailyForecast> sevenDayForecasts = [];

  @override
  void initState() {
    super.initState();
    fetchSevenDayForecast();
  }

  Future<void> fetchSevenDayForecast() async {
     Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final latitude = position.latitude;
      final longitude = position.longitude;


    final url = Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=${latitude},${longitude}&days=7&aqi=no&alerts=no');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List<dynamic> forecastData = data['forecast']['forecastday'];
setState(() {
        nextDayWeather = DailyForecast.fromJson(forecastData[1]);
      });
      setState(() {
        sevenDayForecasts = forecastData
            .map((day) => DailyForecast.fromJson(day))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch seven-day forecast');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                  backgroundColor:  Color(0xff081b25),
     
      body: Column(children: [
        nextDayWeather == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              height:300,
               margin:const EdgeInsets.only(right:18, left:18),
               decoration: BoxDecoration(  color:Colors.purple,
          borderRadius: BorderRadius.circular(40), 
          gradient:const LinearGradient(colors:[ 
            Colors.purple,
            Color.fromARGB(255, 21, 93, 201)
            ],
            )),
           child: Column(children: [
         Padding(padding:EdgeInsets.all(10),  child: Row(children: [
              IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder:(context)=> MainScreen()));}, icon: Icon(Icons.arrow_back,color:Colors.white, size:30)),
              SizedBox(width:80),
              IconButton(onPressed: (){}, icon: Icon(Icons.calendar_month,color:Colors.white, size:30)),
              Text('7 days',style:TextStyle(color:Colors.white, fontSize:25,fontWeight: FontWeight.bold))
            ],)),
            Row(children: [
              Container(height:150, width:150,child:Image.asset('icon/day/116.png', fit: BoxFit.fill,)),
              SizedBox(width:50),
             Column(children: [ Text('Tomorrow',style:TextStyle(color:Colors.white, fontSize:20, )),
               Text('${nextDayWeather!.maxTemperature.toStringAsFixed(1)}°C',style:TextStyle(color:Colors.white, fontSize:50, fontWeight: FontWeight.bold)),
              Text( 'Mostly cloudy',style:TextStyle(color:Colors.white, fontSize:18, ))]),
            ]),
            SizedBox(height:20),
            Divider(),
           
           ],),
            ),
      sevenDayForecasts.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Expanded(child:ListView.builder(
              itemCount: sevenDayForecasts.length,
              itemBuilder: (context, index) {
                 DailyForecast forecast = sevenDayForecasts[index];


                return Container(height:70,
                padding:EdgeInsets.all(10),
               child: Row(children: [
                Text(forecast.dayOfWeek,style:TextStyle(color:Colors.white, fontSize:18, fontWeight: FontWeight.bold)),
                SizedBox(width:120),
              //  Image.network(
  //'https:${forecast.conditionIcon}',),

                SizedBox(width:10),
                Text(forecast.conditionText,style:TextStyle(color:Colors.white, fontSize:18, fontWeight: FontWeight.bold)),
               ],
                  )
                );
             
              },)
            ),])
    );
  }
}