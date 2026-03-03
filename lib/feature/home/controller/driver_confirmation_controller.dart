import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nader_driver/feature/home/controller/rider_info_api_controller.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/network_caller/endpoints.dart';
import '../../../core/shared_preference/shared_preferences_helper.dart';
import '../model/online_ride_model.dart';
import 'online_ride_controller.dart';

class DriverConfirmationController extends GetxController {
  OnlineRideController get onlineRideController =>
      Get.find<OnlineRideController>();
  RiderInfoApiController get riderInfoApiController =>
      Get.find<RiderInfoApiController>();

  var isLoading = false.obs;
  var markerPosition = LatLng(23.749341, 90.437213).obs;
  var destinationPosition = LatLng(23.749704, 90.430164).obs;
  var driverCurrentPosition = LatLng(23.76986878620318, 90.40331684214348).obs;

  // Real-time driver position from geolocator
  var driverRealTimePosition = LatLng(23.76986878620318, 90.40331684214348).obs;
  var isDriverMoving = true.obs;
  var isLocationTracking = false.obs;

  var pickupTime = ''.obs;
  var distance = 0.0.obs;
  var riderInfo = Rxn<OnlineRideModel>();

  // Route information
  var driverToPickupTime = '5 mins'.obs;
  var pickupToDestinationTime = '15 mins'.obs;

  OnlineRideModel? currentRide;
  String? transportId;

  // WebSocket
  var channel = Rxn<WebSocketChannel>();
  Timer? _locationTimer;
  Timer? _driverMovementTimer;
  StreamSubscription<Position>? _positionStreamSubscription;

  // Marker icons
  BitmapDescriptor customMarkerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor customMarkerIconDriver = BitmapDescriptor.defaultMarker;
  BitmapDescriptor customMarkerDestination = BitmapDescriptor.defaultMarker;

  // Markers and Polylines
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs;

  // Camera position for auto zoom
  var cameraPosition = LatLng(23.749341, 90.437213).obs;
  var cameraZoom = 14.0.obs;

  var currentBottomSheet = 1.obs;
  var selectedIndex = 0.obs;

  // Add missing properties
  var isBottomSheetOpen = true.obs;

  // Completer for map controller
  Completer<GoogleMapController> mapController = Completer();

  // Route information for display
  var routeInfo = <String, Map<String, dynamic>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    await _loadCustomMarkers();
    // Initialize real-time position with current device location
    await _getCurrentDeviceLocation();

    print('🚀 Controller initialized');
    print('📍 Initial driver position: ${driverCurrentPosition.value}');
    print('📍 Initial real-time position: ${driverRealTimePosition.value}');

    // Start WebSocket connection for real-time updates
    connectWebSocket();
  }

  // Get current device location
  Future<void> _getCurrentDeviceLocation() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('❌ Location permission denied');
          Get.snackbar(
            'Location Permission Required',
            'Please enable location permissions for real-time tracking',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ Location permission permanently denied');
        Get.snackbar(
          'Location Permission Required',
          'Please enable location permissions from app settings',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Get current position
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final devicePosition = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      // Update both current and real-time positions with device location
      driverCurrentPosition.value = devicePosition;
      driverRealTimePosition.value = devicePosition;

      print(
        '📍 Current device location: ${devicePosition.latitude}, ${devicePosition.longitude}',
      );
    } catch (e) {
      print('❌ Error getting device location: $e');
      // Fallback to default position
      final defaultPosition = LatLng(23.76986878620318, 90.40331684214348);
      driverCurrentPosition.value = defaultPosition;
      driverRealTimePosition.value = defaultPosition;
      print('📍 Using default driver position: $defaultPosition');
    }
  }

  Future<void> _loadCustomMarkers() async {
    try {
      // For now using default markers, you can replace with asset images
      customMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      );
      customMarkerIconDriver = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      );
      customMarkerDestination = BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      );

      print('✅ Custom markers loaded');
    } catch (e) {
      print('❌ Error loading custom markers: $e');
      // Fallback to default markers
      customMarkerIcon = BitmapDescriptor.defaultMarker;
      customMarkerIconDriver = BitmapDescriptor.defaultMarker;
      customMarkerDestination = BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> startLocationTracking() async {
    await _startLocationTracking();
  }

  Future<void> setCurrentRide(OnlineRideModel ride) async {
    print('🚀 Starting setCurrentRide for: ${ride.id}');

    currentRide = ride;
    transportId = ride.id ?? 'unknown';

    // Ensure transportId is properly set
    if (transportId == null || transportId!.isEmpty) {
      transportId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
      print('⚠️ Using temporary transportId: $transportId');
    }

    print('✅ transportId set to: $transportId');

    // Use data from RiderInfoApiController with null checks
    markerPosition.value = LatLng(
      ride.pickupLat ?? 23.749341,
      ride.pickupLng ?? 90.437213,
    );
    destinationPosition.value = LatLng(
      ride.dropOffLat ?? 23.749704,
      ride.dropOffLng ?? 90.430164,
    );

    // API থেকে DriverLatLng না নিয়ে, শুধুমাত্র device location ব্যবহার করুন
    print('📍 Using device location instead of API driver position');

    // Get current device location
    await _getCurrentDeviceLocation();

    pickupTime.value = ride.pickupTime ?? 'Unknown';
    distance.value = ride.distance ?? 0.0;

    print('📍 Setting ride: ${ride.id}');
    print('📍 Pickup: ${ride.pickupLat}, ${ride.pickupLng}');
    print('📍 Destination: ${ride.dropOffLat}, ${ride.dropOffLng}');
    print('📍 Using device location as driver position');
    print(
      '📍 Status: ${ride.status}, ArrivalConfirmation: ${ride.arrivalConfirmation}',
    );

    // Clear existing markers and polylines
    markers.clear();
    polylines.clear();
    routeInfo.clear();

    print('🗺️ Setting up map markers...');
    // Setup markers and routes based on status and arrivalConfirmation
    await _setupMapMarkers();

    print('🛣️ Setting up routes...');
    await _setupRoutesBasedOnStatus();

    print('📍 Starting location tracking...');
    // Start real-time location tracking with geolocator
    await _startLocationTracking();

    // WebSocket reconnect ensure করুন
    if (channel.value == null) {
      print('🔄 Reconnecting WebSocket...');
      connectWebSocket();
    }

    // Force UI update
    update();

    print(
      '✅ All setup complete - Markers: ${markers.length}, Polylines: ${polylines.length}',
    );
  }

  Future<void> _setupMapMarkers() async {
    // Clear existing markers first
    markers.clear();

    print('📍 Adding pickup marker at: ${markerPosition.value}');
    // Add pickup marker
    _addMarkerWithId(
      markerPosition.value,
      'pickup',
      'Pickup Point',
      customMarkerIcon,
    );

    print('📍 Adding destination marker at: ${destinationPosition.value}');
    // Add destination marker
    _addMarkerWithId(
      destinationPosition.value,
      'destination',
      'Destination',
      customMarkerDestination,
    );

    // Ensure driver position is properly set before adding marker
    print(
      '📍 Driver real-time position before marker: ${driverRealTimePosition.value}',
    );
    print(
      '📍 Driver current position before marker: ${driverCurrentPosition.value}',
    );

    // Use the most recent driver position
    final driverPos = driverRealTimePosition.value;
    print('📍 Adding driver marker at: $driverPos');

    // Add initial driver marker
    _addMarkerWithId(
      driverPos,
      'driver',
      'You (Driver)',
      customMarkerIconDriver,
    );

    print('📍 Markers added: ${markers.length}');
    print(
      '📍 All markers: ${markers.map((m) => '${m.markerId.value}: ${m.position}').join(', ')}',
    );

    // Force UI update
    update();
  }

  Future<void> _setupRoutesBasedOnStatus() async {
    if (currentRide == null) return;

    isLoading.value = true;

    try {
      polylines.clear();
      routeInfo.clear();

      print(
        '🛣️ Drawing orange (Driver→Pickup) and yellow (Pickup→Destination)',
      );

      await _fetchAndDrawDriverToPickupRoute();
      await _fetchAndDrawPickupToDestinationRoute();

      await zoomToFitAllPoints();
    } catch (e) {
      print('❌ Error setting up routes: $e');
      _createFallbackRoutes();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _setupAllRoutes() async {
    isLoading.value = true;

    try {
      print('🛣️ Setting up all routes...');

      // 1. Driver to Pickup route
      await _fetchAndDrawDriverToPickupRoute();

      // 2. Pickup to Destination route
      await _fetchAndDrawPickupToDestinationRoute();

      // 3. Auto-zoom to fit all points
      await zoomToFitAllPoints();
    } catch (e) {
      print('❌ Error setting up routes: $e');
      // Fallback to manual routes
      _createFallbackRoutes();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchAndDrawDriverToPickupRoute() async {
    try {
      final currentDriverPosition = driverRealTimePosition.value;
      print(
        '🛣️ Fetching route from device location: $currentDriverPosition to ${markerPosition.value}',
      );

      final routePoints = await _fetchRoutePoints(
        currentDriverPosition,
        markerPosition.value,
      );

      if (routePoints.isNotEmpty) {
        _addPolylineToMap(
          routePoints,
          'driver_to_pickup',
          Colors.orange,
          5,
          'Driver to Pickup',
        );

        // Calculate and update ETA
        final eta = await _calculateETA(routePoints);
        driverToPickupTime.value = eta;

        print('✅ Driver to Pickup route drawn with ETA: $eta');
      } else {
        throw Exception('No route points received');
      }
    } catch (e) {
      print('❌ Failed to fetch driver route: $e');
      _createManualDriverRoute();
    }
  }

  Future<void> _fetchAndDrawDriverToDropoffRoute() async {
    try {
      final currentDriverPosition = driverRealTimePosition.value;
      print(
        '🛣️ Fetching route from device location: $currentDriverPosition to ${destinationPosition.value}',
      );

      final routePoints = await _fetchRoutePoints(
        currentDriverPosition,
        destinationPosition.value,
      );

      if (routePoints.isNotEmpty) {
        _addPolylineToMap(
          routePoints,
          'driver_to_pickup',
          Colors.orange,
          5,
          'Driver to Dropoff',
        );

        // Calculate and update ETA
        final eta = await _calculateETA(routePoints);
        pickupToDestinationTime.value = eta;

        print('✅ Driver to Dropoff route drawn with ETA: $eta');
      } else {
        throw Exception('No route points received');
      }
    } catch (e) {
      print('❌ Failed to fetch dropoff route: $e');
      _createManualDropoffRoute();
    }
  }

  Future<void> _fetchAndDrawPickupToDestinationRoute() async {
    try {
      final routePoints = await _fetchRoutePoints(
        markerPosition.value,
        destinationPosition.value,
      );

      if (routePoints.isNotEmpty) {
        _addPolylineToMap(
          routePoints,
          'pickup_to_destination',
          Colors.yellow,
          5,
          'Pickup to Destination',
        );

        // Calculate and update ETA
        final eta = await _calculateETA(routePoints);
        pickupToDestinationTime.value = eta;

        print('✅ Pickup to Destination route drawn with ETA: $eta');
      } else {
        throw Exception('No route points received');
      }
    } catch (e) {
      print('❌ Failed to fetch destination route: $e');
      _createManualDestinationRoute();
    }
  }

  void _addPolylineToMap(
    List<LatLng> points,
    String routeId,
    Color color,
    int width,
    String info,
  ) {
    if (points.isEmpty) {
      print('❌ No points to add for $routeId');
      return;
    }

    polylines.removeWhere((p) => p.polylineId.value == routeId);

    print('🛣️ Adding polyline: $routeId with ${points.length} points');

    final polyline = Polyline(
      polylineId: PolylineId(routeId),
      points: points,
      color: color,
      width: width,
      geodesic: true,
      consumeTapEvents: true,
    );

    polylines.add(polyline);

    final distance = _calculateDistance(points.first, points.last);

    routeInfo[routeId] = {
      'color': color,
      'duration': info,
      'distance': distance.toStringAsFixed(1),
      'points': points.length,
    };

    print(
      '✅ $routeId added with ${points.length} points, distance: ${distance.toStringAsFixed(1)}km',
    );
    print('📍 Total polylines: ${polylines.length}');

    // Force UI update
    update();
  }

  // Real-time location tracking with geolocator
  Future<void> _startLocationTracking() async {
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('❌ Location permission denied');
          Get.snackbar(
            'Location Permission Required',
            'Please enable location permissions for real-time tracking',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ Location permission permanently denied');
        Get.snackbar(
          'Location Permission Required',
          'Please enable location permissions from app settings',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLocationTracking.value = true;
      print('📍 Starting real-time location tracking...');

      // Get current position first
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update driver position with current device location
      final initialPosition = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      _updateDriverPosition(initialPosition);

      print(
        '📍 Initial device location: ${currentPosition.latitude}, ${currentPosition.longitude}',
      );

      // Start listening to position changes
      _positionStreamSubscription =
          Geolocator.getPositionStream(
            locationSettings: LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10, // Update every 10 meters
            ),
          ).listen(
            (Position position) {
              final newPosition = LatLng(position.latitude, position.longitude);
              print(
                '📍 New device location: ${position.latitude}, ${position.longitude}',
              );

              // Update driver position with real device location
              _updateDriverPosition(newPosition);

              // Send location update via WebSocket
              _sendLocationUpdate(newPosition);
            },
            onError: (error) {
              print('❌ Location tracking error: $error');
              Get.snackbar(
                'Location Error',
                'Failed to track location: $error',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
          );

      print('✅ Real-time location tracking started successfully');
    } catch (e) {
      print('❌ Error starting location tracking: $e');
      Get.snackbar(
        'Location Error',
        'Failed to start location tracking: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _updateDriverPosition(LatLng newPosition) {
    // Update real-time position
    driverRealTimePosition.value = newPosition;
    driverCurrentPosition.value = newPosition;

    print('📍 Updating driver position from device: $newPosition');

    // Remove existing driver marker
    markers.removeWhere((marker) => marker.markerId.value == 'driver');

    // Add new driver marker
    _addMarkerWithId(
      newPosition,
      'driver',
      'You (Driver)',
      customMarkerIconDriver,
    );

    // Send location update via WebSocket
    _sendLocationUpdate(newPosition);

    // Update camera position to follow driver
    _updateCameraPosition(newPosition);

    // Update routes based on new position
    _updateRoutesWithNewPosition(newPosition);

    // Force UI update
    update();
  }

  // নতুন position এর সাথে routes update করার মেথড
  void _updateRoutesWithNewPosition(LatLng newPosition) {
    if (currentRide == null) return;

    print('🔄 Updating routes with new driver position: $newPosition');

    // Clear existing driver-related polylines
    polylines.removeWhere(
      (polyline) => polyline.polylineId.value == 'driver_to_pickup',
    );

    _fetchAndDrawDriverToPickupRoute();
  }

  void _updateCameraPosition(LatLng newPosition) {
    cameraPosition.value = newPosition;

    if (mapController.isCompleted) {
      mapController.future.then((controller) {
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(newPosition, cameraZoom.value),
        );
        print(
          '🎯 Camera animated to: $newPosition with zoom: ${cameraZoom.value}',
        );
      });
    } else {
      print(
        '🎯 Map controller not ready, camera position updated to: $newPosition',
      );
    }
  }

  void _addMarkerWithId(
    LatLng position,
    String id,
    String label,
    BitmapDescriptor icon,
  ) {
    final marker = Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(title: label),
      icon: icon,
    );
    markers.add(marker);
    print('✅ Added marker: $id at $position');
  }

  // Manual route creation fallbacks
  void _createFallbackRoutes() {
    print('🛠️ Creating fallback routes...');
    _createManualDriverRoute();
    _createManualDestinationRoute();
    print('✅ Fallback routes created');
  }

  void _createManualDriverRoute() {
    final points = _createRealisticRoute(
      driverRealTimePosition.value,
      markerPosition.value,
    );

    _addPolylineToMap(
      points,
      'driver_to_pickup',
      Colors.orange,
      5,
      'Driver to Pickup (Manual)',
    );

    driverToPickupTime.value = '8 mins';
  }

  void _createManualDropoffRoute() {
    final points = _createRealisticRoute(
      driverRealTimePosition.value,
      destinationPosition.value,
    );

    _addPolylineToMap(
      points,
      'driver_to_dropoff',
      Colors.green,
      5,
      'Driver to Dropoff (Manual)',
    );

    pickupToDestinationTime.value = '15 mins';
  }

  void _createManualDestinationRoute() {
    final points = _createRealisticRoute(
      markerPosition.value,
      destinationPosition.value,
    );

    _addPolylineToMap(
      points,
      'pickup_to_destination',
      Colors.yellow,
      5,
      'Pickup to Destination (Manual)',
    );

    pickupToDestinationTime.value = '12 mins';
  }

  List<LatLng> _createRealisticRoute(LatLng start, LatLng end) {
    final points = <LatLng>[];
    final steps = 15;

    for (int i = 0; i <= steps; i++) {
      final ratio = i / steps;
      final lat = start.latitude + (end.latitude - start.latitude) * ratio;
      final lng = start.longitude + (end.longitude - start.longitude) * ratio;

      // Add some curvature to make it look like a real road
      final curvedLat = lat + math.sin(ratio * math.pi) * 0.001;
      final curvedLng = lng + math.cos(ratio * math.pi) * 0.001;

      points.add(LatLng(curvedLat, curvedLng));
    }

    return points;
  }

  Future<String> _calculateETA(List<LatLng> routePoints) async {
    if (routePoints.length < 2) return 'Calculating...';

    double totalDistance = 0.0;
    for (int i = 1; i < routePoints.length; i++) {
      totalDistance += _calculateDistance(routePoints[i - 1], routePoints[i]);
    }

    // Assume average speed of 30 km/h in Dhaka traffic
    final hours = totalDistance / 30.0;
    final minutes = (hours * 60).ceil();

    return '$minutes mins';
  }

  // Existing methods for API route fetching
  Future<List<LatLng>> _fetchRoutePoints(
    LatLng origin,
    LatLng destination,
  ) async {
    try {
      const String googleApiKey = 'AIzaSyC7AoMhe2ZP3iHflCVr6a3VeL0ju0bzYVE';
      final String originStr = '${origin.latitude},${origin.longitude}';
      final String destStr = '${destination.latitude},${destination.longitude}';

      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=$originStr&destination=$destStr&mode=driving&key=$googleApiKey';

      print('🚀 API Call: $originStr → $destStr');

      final response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 10));

      print('📡 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        print('🗺️ API Status: ${data['status']}');

        if (data['status'] == 'OK') {
          final routes = data['routes'] as List;
          if (routes.isNotEmpty) {
            final route = routes[0];
            final overviewPolyline = route['overview_polyline'];
            final points = overviewPolyline['points'] as String;

            // Get duration and distance from API
            final legs = route['legs'] as List;
            if (legs.isNotEmpty) {
              final leg = legs[0];
              final duration = leg['duration'];
              final distance = leg['distance'];
              final durationText = duration['text'] as String;
              final distanceText = distance['text'] as String;

              print('⏱️ Route duration: $durationText');
              print('📏 Route distance: $distanceText');
            }

            final List<LatLng> decodedPoints = _decodePolyline(points);
            print('✅ Decoded ${decodedPoints.length} points from API');
            return decodedPoints;
          }
        } else {
          print('❌ API Error: ${data['status']}');
          if (data['error_message'] != null) {
            print('❌ Error Message: ${data['error_message']}');
          }
          throw Exception('API Error: ${data['status']}');
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Network Error: $e');
      rethrow;
    }

    return [];
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      // Decode latitude
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;

      // Decode longitude
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    final latDiff = (point1.latitude - point2.latitude).abs() * 111.32;
    final lngDiff =
        (point1.longitude - point2.longitude).abs() *
        111.32 *
        math.cos((point1.latitude + point2.latitude) / 2 * math.pi / 180);
    return math.sqrt(latDiff * latDiff + lngDiff * lngDiff);
  }

  Future<void> zoomToFitAllPoints() async {
    // Collect all points from markers
    final allPoints = <LatLng>[
      driverRealTimePosition.value,
      markerPosition.value,
      destinationPosition.value,
    ];

    // Add points from all polylines
    for (final polyline in polylines) {
      allPoints.addAll(polyline.points);
    }

    if (allPoints.isEmpty) {
      print('❌ No points to zoom to');
      return;
    }

    double minLat = allPoints[0].latitude;
    double maxLat = allPoints[0].latitude;
    double minLng = allPoints[0].longitude;
    double maxLng = allPoints[0].longitude;

    for (final point in allPoints) {
      minLat = math.min(minLat, point.latitude);
      maxLat = math.max(maxLat, point.latitude);
      minLng = math.min(minLng, point.longitude);
      maxLng = math.max(maxLng, point.longitude);
    }

    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;

    cameraPosition.value = LatLng(centerLat, centerLng);

    final latDistance = (maxLat - minLat).abs();
    final lngDistance = (maxLng - minLng).abs();
    final maxDistance = math.max(latDistance, lngDistance);

    // Adjust zoom level based on distance
    if (maxDistance < 0.01) {
      cameraZoom.value = 15.0;
    } else if (maxDistance < 0.02) {
      cameraZoom.value = 14.0;
    } else if (maxDistance < 0.05) {
      cameraZoom.value = 13.0;
    } else {
      cameraZoom.value = 12.0;
    }

    print(
      '🎯 Zooming to: $centerLat, $centerLng with zoom: ${cameraZoom.value}',
    );

    if (mapController.isCompleted) {
      final controller = await mapController.future;
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(cameraPosition.value, cameraZoom.value),
      );
      print('✅ Camera animation complete');
    }
  }

  // Enhanced WebSocket methods
  // এই version টি directly use করুন
  Future<void> connectWebSocket() async {
    if (channel.value != null) {
      print('ℹ️ WebSocket already connected');
      return;
    }

    try {
      final token = await SharedPreferencesHelper.getAccessToken();
      if (token == null || token.isEmpty) {
        print('❌ No token available for WebSocket');
        return;
      }

      print('🔄 Connecting WebSocket...');
      channel.value = WebSocketChannel.connect(Uri.parse(NetworkPath.ws));

      // Authenticate
      channel.value!.sink.add(
        json.encode({"event": "authenticate", "token": token}),
      );

      print('✅ WebSocket connected and authenticated');

      // Message handler
      channel.value!.stream.listen(
        (message) {
          print('📨 WebSocket: $message');
          _handleWebSocketMessage(message);
        },
        onError: (error) {
          print('❌ WebSocket error: $error');
          _reconnectWebSocket();
        },
        onDone: () {
          print('🔌 WebSocket disconnected');
          _reconnectWebSocket();
        },
      );

      // Location updates - SIMPLIFIED
      _locationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (isLocationTracking.value) {
          _sendSimpleLocationUpdate(driverRealTimePosition.value);
        }
      });
    } catch (e) {
      print('❌ Error connecting WebSocket: $e');
      _reconnectWebSocket();
    }
  }

  void _sendSimpleLocationUpdate(LatLng position) async {
    if (channel.value == null) return;

    try {
      final transportId = await SharedPreferencesHelper.getUserId();
      if (transportId == null || transportId.isEmpty) return;

      // SIMPLEST POSSIBLE FORMAT
      final message = json.encode({
        "event": "locationUpdate", // এই event name টি try করুন
        "transportId": transportId,
        "lat": position.latitude,
        "lng": position.longitude,
        // অন্য কোনো field add করবেন না
      });

      channel.value!.sink.add(message);
      print('📡 Location sent: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('❌ Error sending location: $e');
    }
  }

  void _handleWebSocketMessage(String message) {
    try {
      final data = json.decode(message);
      final event = data['event'];

      if (event == 'authenticated') {
        print('🎉 WebSocket authentication successful!');
      } else if (event == 'error') {
        print('❌ Server error: ${data['message']}');
      } else if (event == 'locationUpdate' || event == 'driverLocation') {
        print('📍 Location update received');
      } else {
        print('📨 Other event: $event');
      }
    } catch (e) {
      print('⚠️ Error parsing message: $e');
    }
  }

  void _handleRideStatusUpdate(Map<String, dynamic> data) {
    final status = data['status'] as String?;
    print('🔄 Ride status updated: $status');

    // You can handle different status updates here
    if (status == 'completed' || status == 'cancelled') {
      // Stop location updates
      isDriverMoving.value = false;
      _driverMovementTimer?.cancel();
    }
  }

  void _sendLocationUpdate(LatLng position) {
    if (channel.value == null) {
      print('❌ WebSocket channel not connected');
      return;
    }

    // transportId null check করুন
    if (transportId == null || transportId!.isEmpty) {
      print('❌ transportId is null or empty, cannot send location update');

      // Fallback: currentRide থেকে transportId নেওয়ার চেষ্টা করুন
      if (currentRide?.id != null) {
        transportId = currentRide!.id;
        print('🔄 Using transportId from currentRide: $transportId');
      } else {
        print('❌ No transportId available for WebSocket update');
        return;
      }
    }

    try {
      final update = {
        "event": "driverLocationUpdate",
        "transportId": transportId,
        "lat": position.latitude,
        "lng": position.longitude,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "speed": 30.0,
        "bearing": 45.0,
        "source": "device_geolocator",
        "accuracy": 10.0, // accuracy যোগ করুন
        "isMoving": isDriverMoving.value, // movement status যোগ করুন
      };

      channel.value!.sink.add(json.encode(update));
      print(
        '📍 Sent real-time device location update: ${position.latitude}, ${position.longitude}',
      );
      print('📡 WebSocket data: ${json.encode(update)}');
    } catch (e) {
      print('❌ Error sending location update: $e');
    }
  }

  void _reconnectWebSocket() {
    if (_locationTimer != null) {
      _locationTimer!.cancel();
      _locationTimer = null;
    }

    Future.delayed(Duration(seconds: 5), () {
      print('🔄 Attempting WebSocket reconnection...');
      connectWebSocket();
    });
  }

  Future<void> refreshRoutes() async {
    print('🔄 Manually refreshing routes...');

    // Clear existing data
    polylines.clear();
    routeInfo.clear();

    // Re-fetch routes
    await _setupAllRoutes();

    Get.snackbar(
      'Routes Updated',
      'Routes have been refreshed',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Get current location manually
  Future<void> getCurrentLocationManually() async {
    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final newPosition = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      _updateDriverPosition(newPosition);

      Get.snackbar(
        'Location Updated',
        'Current device location fetched',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get current location: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void selectContainerEffect(int index) {
    selectedIndex.value = index;
  }

  void changeSheet(int value, {String? data}) {
    currentBottomSheet.value = value;
    isBottomSheetOpen.value = true; // Ensure bottom sheet is open when changing
  }

  @override
  void onClose() {
    disconnectWebSocket();
    super.onClose();
  }

  void disconnectWebSocket() {
    _locationTimer?.cancel();
    _locationTimer = null;

    _driverMovementTimer?.cancel();
    _driverMovementTimer = null;

    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    isLocationTracking.value = false;

    if (channel.value != null) {
      channel.value!.sink.close();
      channel.value = null;
    }
    print('WebSocket disconnected');
  }
}
