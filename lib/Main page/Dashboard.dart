import 'package:educute/Catatan/catatan.dart';
import 'package:educute/Login&Register/Login.dart';
import 'package:educute/Tugas/tugas.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String temperature = '';
  String city = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await Dio().get(
          'https://openweathermap.org/data/2.5/weather?id=1214520&appid=439d4b804bc8187953eb36d2a8c26a02');
      if (response.statusCode == 200) {
        final temperatureValue =
            response.data['main']['temp'].toStringAsFixed(1);
        final cityValue = response.data['name'];
        setState(() {
          temperature = '$temperatureValue °C';
          city = '$cityValue';
          isLoading = false;
        });
      } else {
        print('Failed to load weather data');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Selamat Datang',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                isLoading
                    ? const Text("Sedang memuat suhu saat ini...")
                    : Text("Suhu saat ini di $city $temperature"),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(25),
              crossAxisCount: 2,
              children: [
                Card(
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CatatanScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.blue,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.book,
                            size: 70,
                            color: Colors.blueAccent,
                          ),
                          Text("Catatan", style: TextStyle(fontSize: 17.0)),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TugasScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.blue,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.task,
                            size: 70,
                            color: Colors.green,
                          ),
                          Text("Tugas", style: TextStyle(fontSize: 17.0)),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    splashColor: Colors.blue,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.logout_outlined,
                            size: 70,
                            color: Colors.redAccent,
                          ),
                          Text("Log out", style: TextStyle(fontSize: 17.0)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
