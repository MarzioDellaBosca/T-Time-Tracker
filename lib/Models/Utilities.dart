import 'package:flutter/material.dart' hide Key;

class Utility {
  static void errorDiag(String msg, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Error!',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static String padKey(String key) {
    if (key.length > 32) {
      return key.substring(
          0, 32); // Se la chiave è più lunga di 32 caratteri, troncala
    } else {
      return key.padRight(32,
          '.'); // Altrimenti, aggiungi '.' alla fine fino a raggiungere 32 caratteri
    }
  }

  static bool isNotValidDuration(String dur) {
    try {
      int.parse(dur);
      return false;
    } catch (e) {
      return true;
    }
  }

  static String getWeatherIcon(int condition) {
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

  static String getTempMessage(double temp) {
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
}
