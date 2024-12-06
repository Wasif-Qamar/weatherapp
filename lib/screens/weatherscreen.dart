import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  String _weatherInfo = '';
  bool _isLoading = false;

  Future<void> fetchWeather(String city) async {
    if (city.isEmpty) {
      setState(() {
        _weatherInfo = 'Please enter a city name.';
      });
      return;
    }

    final url = Uri.parse('https://roasted-enchanted-show.glitch.me/weather?city=$city');

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _weatherInfo = '''
City: ${data['city']}
Temperature: ${data['temperature']}°C
Humidity: ${data['humidity']}%
''';
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _weatherInfo = 'City not found. Please try another city.';
        });
      } else {
        setState(() {
          _weatherInfo = 'An error occurred. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _weatherInfo = 'Error: Unable to fetch data. Please check your connection.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter City',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                fetchWeather(_cityController.text.trim());
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 16.0),
            if (_isLoading)
              CircularProgressIndicator()
            else
              Text(
                _weatherInfo,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
              ),
          ],
        ),
      ),
    );
  }
}
