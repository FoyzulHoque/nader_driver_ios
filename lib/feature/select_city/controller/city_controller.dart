import 'package:get/get.dart';
import '../model/city_model.dart';

class CityController extends GetxController {
  var selectedCity = (0).obs;

  final cities = <CityModel>[
    CityModel(name: "United States"),
    CityModel(name: "New York"),
    CityModel(name: "Chicago"),
    CityModel(name: "Houston"),
    CityModel(name: "Phoenix"),
    CityModel(name: "Philadelphia"),
    CityModel(name: "San Diego"),
    CityModel(name: "Dallas"),
    CityModel(name: "Jacksonville"),
    CityModel(name: "Miami"),
    CityModel(name: "Los Angeles"),
    CityModel(name: "San Francisco"),
  ];

  void selectCity(int index) {
    selectedCity.value = index;
    // Get.to(() => CityDetailsScreen(cityName: cities[index].name));
    // Get.to(SignUpScreen());
  }
}
