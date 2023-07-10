import 'package:flutter/material.dart';
import 'package:weather_app/hour2.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:intl/intl.dart';
import 'model/weather.dart';
import 'package:weather_app/services/global.dart';
import 'package:weather_app/hour.dart';
//import 'package:get/get.dart';

//import 'package:geocoding/geocoding.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
   String date = DateFormat("yMMMMd").format(DateTime.now());
   var client = WeatherService();
  var  data;

   info () async{
    var position = await getPosition();

    data = await client.getData(position.latitude, position.longitude,);
    return data;
   }

   Weather weather = Weather();


  @override
  void initState() {
  
   super.initState();
  }



  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor:const Color(0xff081b25),
     body:
    FutureBuilder(
      future: info(),
       builder:((context,snapshot){
     //return  Container(
     //child:
     return
      Column(children: [
      Container(
          height:600,
        width: 900,
        margin:const EdgeInsets.only(right:18, left:18),
        decoration: BoxDecoration(
          color:Colors.purple,
          borderRadius: BorderRadius.circular(40), 
          gradient:const LinearGradient(colors:[ 
            Colors.purple,
            Color.fromARGB(255, 21, 93, 201)
            ],
           
            )
        ),
        //Image.network('https:${data?.icon}',
        child:Column(
         
          children: [
            const SizedBox(height:40),
            Text('Lagos City',style:TextStyle(fontSize: 45,fontWeight: FontWeight.bold, color :Colors.white)),
          // Text('${data?.cityName}',style:TextStyle(fontSize: 45,fontWeight: FontWeight.bold, color :Colors.white)),
       const SizedBox(height:8),
            Text(date,style:TextStyle(fontSize: 22,color :Colors.white)),
            Container(height: 200, child: Image.asset('icon/day/350.png',fit: BoxFit.cover,)),
            //Text('Sunny',style:TextStyle(fontSize: 30,color :Colors.white)),
            Text('${data?.condition}',style:TextStyle(fontSize: 30,color :Colors.white)),
            SizedBox(height:10),
           // Text('29°C',style:TextStyle(fontSize: 40,fontWeight: FontWeight.bold, color :Colors.white)),
            Text('${data?.temperatureC}°C',style:TextStyle(fontSize: 40,fontWeight: FontWeight.bold, color :Colors.white)),
            SizedBox(height:20),
            Row(children: [
              Padding(
      padding: EdgeInsets.only(left: 20.0), child: Column(children: [
                  Container(height: 70, child:Image.asset('wind.png', fit: BoxFit.cover,)),
                   Text('humidity',style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color :Colors.white)),
                   SizedBox(height:10),
                   Text('20',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color :Colors.white)),

              ],),),
                            Spacer(),
              Column(children: [
                  Container(height: 70, child:Image.asset('wind2.png', fit: BoxFit.cover,)),
                   Text('direction',style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color :Colors.white)),
                   SizedBox(height:10),
                   Text('20',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color :Colors.white)),

              ],),
              Spacer(),
                           Padding(
      padding: EdgeInsets.only(right: 20.0),  child:Column(children: [
                  Container(height: 70, child:Image.asset('humidity.png', fit: BoxFit.cover,)),
                   Text('speed',style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color :Colors.white)),
                   SizedBox(height:10),
                   Text('20',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color :Colors.white)),

              ],)),

            ],)


          ],
        )
      ),
      SizedBox(height:20),
   Padding(padding:EdgeInsets.symmetric(horizontal: 20) , child:  Row(children: [
        Text('Today',style:TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        Spacer(),
        InkWell(
          onTap:(){Navigator.push(context, MaterialPageRoute(builder:(context)=> WeatherScreen()));},child: Text('7 days',style:TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),),
      ],),),
     Padding(padding:EdgeInsets.all(10) ,
    child:Container(
        //margin:const EdgeInsets.only(right:10, left:5),
        color:Color(0xff081b25),
        height:200,
       
        child:HourlyForecastScreen()),
     )
      ,
 
  
     ],);
       }
       )
     )
    );
  }
}
