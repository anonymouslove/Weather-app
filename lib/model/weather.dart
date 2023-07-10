class Weather {
  var cityName;
   var temperatureC;
  var temperatureF;
  var condition;
  var  icon;
var windir;
  var humidity;
var cloud;
var windkph;

  Weather({
    this.cityName,
    this.temperatureC,
    this.temperatureF,
    this.condition,
    this.icon,
    this.windir,
     this.humidity,
   this.cloud,
   this.windkph,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
       cityName: json['location']['name'],
      temperatureC: json['current']['temp_c'],
      temperatureF: json['current']['temp_f'],
      condition: json['current']['condition']['text'],
      icon: json['current']['condition']['icon'],
      windir: json['wind_dir'],
      humidity: json['current']['humidity'],
      cloud: json['current']['cloud'],
      windkph: json['wind_kph'],
    );
  }
}
