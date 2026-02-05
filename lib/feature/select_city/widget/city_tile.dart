import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/city_controller.dart';
import '../widget/custom_radio_button.dart';

class CityTile extends StatelessWidget {
  final int index;
  final String cityName;

  const CityTile({super.key, required this.index, required this.cityName});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CityController>();

    return Obx(() {
      bool isSelected = controller.selectedCity.value == index;

      return GestureDetector(
        onTap: () => controller.selectCity(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            children: [
              CustomRadioButton(isSelected: isSelected),
              const SizedBox(width: 12),
              Text(
                cityName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
