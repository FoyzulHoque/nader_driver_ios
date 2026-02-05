import 'package:flutter/material.dart';

class CityDetailsScreen extends StatelessWidget {
  final String cityName;

  const CityDetailsScreen({super.key, required this.cityName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cityName),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Welcome to $cityName!",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
