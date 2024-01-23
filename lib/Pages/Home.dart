import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Position? _currentPosition;
  var style =
      TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold);

  Future<void> _determineIP() async {
    final responseIp = await http.get(Uri.parse('https://api.ipify.org'));
    if (responseIp.statusCode == 200) {
      String ip = responseIp.body;
      print(ip);

      final responseLoc = await http.get(Uri.parse(
          'https://api.ipgeolocation.io/ipgeo?apiKey=3053e1109ad84501acd6ed29471d2ccb&ip=$ip'));
      if (responseLoc.statusCode == 200) {
        String loc = responseLoc.body;
        //print(loc);

        Map<String, dynamic> map = json.decode(loc);

        print(map['city']);
        print(map['latitude']);
        print(map['longitude']);

        final responseWeather = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=${map['latitude']}&lon=${map['longitude']}&appid=42e97e9acd8667854d957907b52ea325&units=metric'));

        if (responseWeather.statusCode == 200) {
          String weather = responseWeather.body;
          print(weather);

          Map<String, dynamic> mapWeather = json.decode(weather);

          print(mapWeather['main']['temp']);
          print(mapWeather['weather'][0]['description']);
        } else {
          throw Exception('Failed to get Weather');
        }
      } else {
        throw Exception('Failed to get Location');
      }
    } else {
      throw Exception('Failed to get IP address');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: Container(
              height: 300,
              width: 400,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "Hello",
                    style: style,
                  ),
                  ElevatedButton(
                    onPressed: _determineIP,
                    child: Text("Press"),
                  )
                  /*   Text(
                    
                    _currentPosition != null
                        ? 'Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}'
                        : 'Loading...',
                    style: style,
                  ),*/
                ],
              )),
        )
      ],
    ));
  }
}
