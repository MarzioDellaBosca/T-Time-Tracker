import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Widgets/DigitalClock.dart';
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

  String _getWeatherIcon(int condition) {
    if (condition < 300 && condition >= 0) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String _getTempMessage(double temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }

  Future<List<String>> _determineIP() async {
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

        // print(map['latitude']);
        //print(map['longitude']);

        final responseWeather = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=${map['latitude']}&lon=${map['longitude']}&appid=42e97e9acd8667854d957907b52ea325&units=metric'));

        if (responseWeather.statusCode == 200) {
          String weather = responseWeather.body;
          //  print(weather);

          Map<String, dynamic> mapWeather = json.decode(weather);
          /*
          print(mapWeather['main']['temp']);
          print(mapWeather['weather'][0]['id']);
          print(map['city']);*/
          print(mapWeather['weather'][0]['main']);
          print(mapWeather['weather'][0]['description']);

          return [
            map['city'].toString(),
            mapWeather['main']['temp'].toString(),
            mapWeather['weather'][0]['id'].toString()
          ];
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

  late Future<String> _city;
  late Future<String> _temp;
  late Future<String> _cond;
  late Future<List<String>> _work;

  @override
  void initState() {
    super.initState();
    _work = _determineIP();
    _city = _work.then((value) => value[0]);
    _temp = _work.then((value) => value[1]);
    _cond = _work.then((value) => value[2]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_city, _temp, _cond]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String city = snapshot.data![0];
            String temp = snapshot.data![1];
            String cond = snapshot.data![2];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text('${city}', style: style),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Container(
                          margin: EdgeInsets.all(10),

                          child: DigitalClock(), //Text('Hour', style: style),
                        ),
                      ),
                      Card(
                        child: Container(
                          width: 100,
                          //margin: EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                                _getWeatherIcon(
                                  int.parse(cond),
                                ),
                                style: TextStyle(fontSize: 50)),
                          ),
                        ),
                      ),
                    ]),
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Card(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          margin: EdgeInsets.all(10),
                          child: Center(child: Text('Hello!', style: style)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Card(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          margin: EdgeInsets.all(10),
                          child: Center(
                              child: Column(
                            children: [
                              SizedBox(height: 20),
                              Text('${temp}°C',
                                  style: TextStyle(
                                      fontSize: 50,
                                      color: double.parse(temp) > 20
                                          ? Colors.red
                                          : Colors.blue,
                                      fontWeight: FontWeight.bold)),
                              Text(_getTempMessage(double.parse(temp)),
                                  style: TextStyle(fontSize: 20)),
                            ],
                          )),
                        ),
                      ),
                    ]))
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return Center(
                child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 6,
                    child: CircularProgressIndicator(
                      color: Colors.white70,
                      strokeWidth: 20,
                    )));
          }
        });
  }
}
