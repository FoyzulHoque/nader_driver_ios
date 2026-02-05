/*

import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  RxBool isLocationAllowed = false.obs;
  Rx<LocationData?> currentLocation = Rx<LocationData?>(null);

  Future<void> requestLocationPermission() async {
    Location location = Location();

    // Permission check
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
    }

    if (permissionStatus == PermissionStatus.granted) {
      isLocationAllowed.value = true;

      // Get current location
      currentLocation.value = await location.getLocation();
    } else {
      isLocationAllowed.value = false;
    }
  }
}
*/
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  final Location _location = Location();

  final isLoading = false.obs;
  final isServiceEnabled = false.obs;
  final isPermissionGranted = false.obs;
  final currentLocation = Rxn<LocationData>();
  final errorMessage = RxnString();

  /// Main method to request service + permission + get location
  Future<bool> requestAndFetchLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      // 1. Check and request location service (GPS)
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          errorMessage.value =
              "Location services are turned off.\nPlease enable GPS in settings.";
          isServiceEnabled.value = false;
          return false;
        }
      }
      isServiceEnabled.value = true;

      // 2. Check and request permission
      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
      }

      if (permission != PermissionStatus.granted) {
        if (permission == PermissionStatus.deniedForever) {
          errorMessage.value =
              "Location permission permanently denied.\nPlease allow it in app settings → Permissions.";
        } else {
          errorMessage.value = "Location permission is required to continue.";
        }
        isPermissionGranted.value = false;
        return false;
      }

      isPermissionGranted.value = true;

      // 3. Get current location
      final locationData = await _location.getLocation();

      if (locationData.latitude == null || locationData.longitude == null) {
        errorMessage.value = "Could not retrieve valid location coordinates.";
        return false;
      }

      currentLocation.value = locationData;
      return true;
    } catch (e) {
      errorMessage.value = "Location error: ${e.toString().split('\n').first}";
      print("Location error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
