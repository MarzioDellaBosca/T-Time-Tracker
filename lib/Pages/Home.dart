import 'package:flutter/material.dart';
import 'package:flutter_tracker_application/Models/Providers.dart';
import 'package:flutter_tracker_application/Widgets/DigitalClock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tracker_application/Models/Utilities.dart';

class Home extends StatefulWidget {
  final String username;
  final imgProvider;
  Home({required this.username, required this.imgProvider});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String get username => widget.username;
  ImgProvider get imgProvider => widget.imgProvider;
  var style =
      TextStyle(fontSize: 30, color: Colors.blue, fontWeight: FontWeight.bold);

  Future<List<String>> _determineIP() async {
    final responseIp = await http.get(Uri.parse('https://api.ipify.org'));
    if (responseIp.statusCode == 200) {
      String ip = responseIp.body;

      final responseLoc = await http.get(Uri.parse(
          'https://api.ipgeolocation.io/ipgeo?apiKey=3053e1109ad84501acd6ed29471d2ccb&ip=$ip'));
      if (responseLoc.statusCode == 200) {
        String loc = responseLoc.body;
        Map<String, dynamic> map = json.decode(loc);

        final responseWeather = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=${map['latitude']}&lon=${map['longitude']}&appid=42e97e9acd8667854d957907b52ea325&units=metric'));

        if (responseWeather.statusCode == 200) {
          String weather = responseWeather.body;
          Map<String, dynamic> mapWeather = json.decode(weather);

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
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgProvider
                      .imgPath), // sostituisci con il tuo percorso di immagine
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
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
                            child: Text(city, style: style),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: DigitalClock(),
                          ),
                        ),
                        Card(
                          child: SizedBox(
                            width: 100,
                            child: Center(
                              child: Text(
                                  Utility.getWeatherIcon(
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
                            child: Center(
                                child: Text('Hello $username!', style: style)),
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
                                Text('$temp°C',
                                    style: TextStyle(
                                        fontSize: 50,
                                        color: double.parse(temp) > 20
                                            ? Colors.red
                                            : Colors.blue,
                                        fontWeight: FontWeight.bold)),
                                Text(Utility.getTempMessage(double.parse(temp)),
                                    style: TextStyle(fontSize: 20)),
                              ],
                            )),
                          ),
                        ),
                      ]))
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return Center(
                child: SizedBox(
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
