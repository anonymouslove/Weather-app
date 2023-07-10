import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather.dart';

class WeatherService {
  Future<Weather> getData(var latitude, var longitude) async {
 
     
      var uriCall =   Uri.parse('http://api.weatherapi.com/v1/current.json?key=2caef2b14d634e6a9de221117230207&q=$latitude,$longitude&aqi=no');
      

      var  response = await http.get(uriCall);
      var body = jsonDecode(response.body);
      if(response.statusCode == 200) {
        return Weather.fromJson(body);
      } else {
        throw Exception("Can not get weather");
      }
      
    } 
  }

///v1/current.json