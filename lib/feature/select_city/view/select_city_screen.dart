import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/city_controller.dart';
import '../widget/city_tile.dart';

class SelectCityScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const SelectCityScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CityController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          "Select City",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: Column(children: [
        CityTile(index: 0, cityName: "United States"),
        CityTile(index: 1, cityName: "New York"),
        CityTile(index: 2, cityName: "Chicago"),
        CityTile(index: 3, cityName: "Houston"),
        CityTile(index: 4, cityName: "Phoenix"),
        CityTile(index: 5, cityName: "Philadelphia"),
        CityTile(index: 6, cityName: "San Diego"),
        CityTile(index: 7, cityName: "Dallas"),
        CityTile(index: 8, cityName: "Jacksonville"),
        CityTile(index: 9, cityName: "Miami"),
        CityTile(index: 10, cityName: "Los Angeles"),
        CityTile(index: 11, cityName: "San Francisco"),

      ],),
      // body: Obx(() => ListView.builder(
      //   itemCount: controller.cities.length,
      //   itemBuilder: (context, index) {
      //     return CityTile(
      //       index: index,
      //       cityName: controller.cities[index].name,
      //     );
      //   },
      // )),
    );
  }
}
