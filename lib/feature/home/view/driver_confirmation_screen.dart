import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../bottom_sheet_dialog_screen/bottom_sheet_eight.dart';
import '../bottom_sheet_dialog_screen/bottom_sheet_five.dart';
import '../bottom_sheet_dialog_screen/bottom_sheet_four.dart';
import '../bottom_sheet_dialog_screen/bottom_sheet_nine.dart';
import '../bottom_sheet_dialog_screen/bottom_sheet_one.dart';
import '../bottom_sheet_dialog_screen/bottom_sheet_seven.dart';
import '../bottom_sheet_dialog_screen/bottom_sheet_six.dart';
import '../bottom_sheet_dialog_screen/bottom_sheet_three.dart';
import '../bottom_sheet_dialog_screen/bottom_sheet_two.dart';
import '../controller/arrival_controller.dart';
import '../controller/driver_confirmation_controller.dart';
import '../controller/home_controller.dart';
import '../controller/online_ride_controller.dart';
import '../controller/rider_info_api_controller.dart';
import '../model/online_ride_model.dart';

class DriverConfirmationScreen extends StatefulWidget {
  const DriverConfirmationScreen({super.key});

  @override
  State<DriverConfirmationScreen> createState() => _DriverConfirmationScreenState();
}

class _DriverConfirmationScreenState extends State<DriverConfirmationScreen> {
  late final DriverConfirmationController driverConfirmationController;
  final HomeController homeController = Get.put(HomeController());
  final ArrivalController controller = Get.put(ArrivalController());
  final RiderInfoApiController riderInfoApiController = Get.put(RiderInfoApiController());
  final OnlineRideController onlineRideController = Get.find<OnlineRideController>();

  @override
  void initState() {
    super.initState();
    driverConfirmationController = Get.find<DriverConfirmationController>();

    // Initialize the screen with sample data or call API
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    try {
      // First try to get data from OnlineRideController
      final onlineRide = onlineRideController.selectedRide.value ??
          onlineRideController.pendingRides.firstOrNull;

      if (onlineRide != null) {
        print('Using OnlineRideController data: ${onlineRide.id}');

        // Try to call RiderInfoApiController with the ride ID
        print('Calling RiderInfoApiController with ID: ${onlineRide.id}');
        final rideData = await riderInfoApiController.riderInfoApiMethod(onlineRide.id ?? 'unknown'); // Handle nullable id

        if (rideData != null) {
          print('RiderInfoApiController data loaded successfully');
          await _setupRideData(rideData);
        } else {
          print('RiderInfoApiController failed, using OnlineRideController data');
          await _setupRideData(onlineRide);
        }
        return;
      }

      // If no online ride data, try to call RiderInfoApiController with a sample ID
      const sampleTransportId = "sample-transport-id"; // Replace with actual ID

      print('Calling RiderInfoApiController with sample ID: $sampleTransportId');
      final rideData = await riderInfoApiController.riderInfoApiMethod(sampleTransportId);

      if (rideData != null) {
        print('RiderInfoApiController data loaded successfully');
        await _setupRideData(rideData);
      } else {
        // Create sample data for testing
        print('Creating sample data for testing');
        await _createSampleRideData();
      }
    } catch (e) {
      print('Error initializing screen: $e');
      // Create sample data as fallback
      await _createSampleRideData();
    }
  }

  Future<void> _setupRideData(OnlineRideModel ride) async {
    print('Setting up ride data: ${ride.id}');
    print('Pickup: (${ride.pickupLat}, ${ride.pickupLng})');
    print('Dropoff: (${ride.dropOffLat}, ${ride.dropOffLng})');
    print('Driver: (${ride.driverLat}, ${ride.driverLng})');
    print('Status: ${ride.status}, ArrivalConfirmation: ${ride.arrivalConfirmation}');

    await driverConfirmationController.setCurrentRide(ride);
    driverConfirmationController.isBottomSheetOpen.value = true;
    print('Bottom sheet initialized: open=${driverConfirmationController.isBottomSheetOpen.value}');
  }

  Future<void> _createSampleRideData() async {
    // Create sample ride data for testing
    final sampleRide = OnlineRideModel(
      id: "sample-ride-001",
      userId: "user-001",
      vehicleId: "vehicle-001",
      pickupLocation: "Dhaka, Bangladesh",
      dropOffLocation: "Chittagong, Bangladesh",
      pickupLat: 23.749341,
      pickupLng: 90.437213,
      dropOffLat: 23.749704,
      dropOffLng: 90.430164,
      driverLat: 23.76986878620318, // Driver's current position
      driverLng: 90.40331684214348, // Driver's current position
      totalAmount: 500.0,
      distance: 15.5,
      paymentMethod: "cash",
      paymentStatus: "pending",
      pickupDate: "2024-01-15",
      pickupTime: "10:30 AM",
      status: "ONGOING",
      serviceType: "standard",
      arrivalConfirmation: false,
    );

    print('Created sample ride data for testing');
    print('Driver position: ${sampleRide.driverLat}, ${sampleRide.driverLng}');
    await _setupRideData(sampleRide);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map with real-time updates
          Obx(() {
            final driverPosition = driverConfirmationController.driverRealTimePosition.value;
            final cameraPosition = driverConfirmationController.cameraPosition.value;
            final cameraZoom = driverConfirmationController.cameraZoom.value;

            print('🗺️ Rendering map with driver position: $driverPosition');
            print('🗺️ Camera position: $cameraPosition, zoom: $cameraZoom');
            print('🗺️ Markers count: ${driverConfirmationController.markers.length}');

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: driverPosition,
                zoom: cameraZoom,
              ),
              markers: driverConfirmationController.markers,
              polylines: driverConfirmationController.polylines,
              onMapCreated: (GoogleMapController controller) {
                driverConfirmationController.mapController.complete(controller);
                print('🗺️ Map created with real-time tracking');
                print('📍 Driver position: $driverPosition');
                print('📍 Markers: ${driverConfirmationController.markers.length}');
                print('🛣️ Polylines: ${driverConfirmationController.polylines.length}');

                // Auto-zoom after map is created
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  driverConfirmationController.zoomToFitAllPoints();
                });
              },
              onCameraMove: (CameraPosition position) {
                // Update camera position in controller
                driverConfirmationController.cameraPosition.value = position.target;
                driverConfirmationController.cameraZoom.value = position.zoom;
              },
            );
          }),

          // Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    print('Back button pressed');
                    Get.back();
                  },
                ),
              ),
            ),
          ),

          // Real-time info panel
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: Obx(() {
              final etaToPickup = driverConfirmationController.driverToPickupTime.value;
              final etaToDestination = driverConfirmationController.pickupToDestinationTime.value;
              final isMoving = driverConfirmationController.isDriverMoving.value;
              final isTracking = driverConfirmationController.isLocationTracking.value;
              final isWebSocketConnected = driverConfirmationController.channel.value != null;

              return Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Real-time Tracking Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'To Pickup: $etaToPickup',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'To Destination: $etaToDestination',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isMoving ? Icons.directions_car : Icons.pin_drop,
                            size: 16,
                            color: isMoving ? Colors.orange : Colors.grey,
                          ),
                          SizedBox(width: 8),
                          Text(
                            isMoving ? 'Driver is moving' : 'Driver stopped',
                            style: TextStyle(
                              color: isMoving ? Colors.orange : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isTracking ? Icons.location_on : Icons.location_off,
                            size: 16,
                            color: isTracking ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            isTracking ? 'Location tracking active' : 'Location tracking off',
                            style: TextStyle(
                              color: isTracking ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isWebSocketConnected ? Icons.cloud_done : Icons.cloud_off,
                            size: 16,
                            color: isWebSocketConnected ? Colors.green : Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            isWebSocketConnected ? 'WebSocket connected' : 'WebSocket disconnected',
                            style: TextStyle(
                              color: isWebSocketConnected ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          // Bottom Sheet
          Obx(() {
            return driverConfirmationController.isBottomSheetOpen.value
                ? buildBottomSheet(driverConfirmationController.currentBottomSheet.value)
                : Container();
          }),
        ],
      ),

      // Floating Action Buttons
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Real-time location button
          FloatingActionButton(
            onPressed: () {
              driverConfirmationController.getCurrentLocationManually();
            },
            child: Icon(Icons.my_location),
            backgroundColor: Colors.orange,
            mini: true,
            tooltip: 'Get Current Device Location',
          ),
          SizedBox(height: 10),

          // Refresh routes button
          FloatingActionButton(
            onPressed: () {
              driverConfirmationController.refreshRoutes();
            },
            child: Icon(Icons.refresh),
            backgroundColor: Colors.blue,
            mini: true,
            tooltip: 'Refresh Routes',
          ),
          SizedBox(height: 10),

          // Zoom to fit button
          FloatingActionButton(
            onPressed: () {
              driverConfirmationController.zoomToFitAllPoints();
            },
            child: Icon(Icons.zoom_out_map),
            backgroundColor: Colors.green,
            mini: true,
            tooltip: 'Zoom to Fit All Points',
          ),

          // WebSocket status indicator
          SizedBox(height: 10),
          Obx(() {
            final isConnected = driverConfirmationController.channel.value != null;
            return FloatingActionButton(
              onPressed: () {
                if (isConnected) {
                  driverConfirmationController.disconnectWebSocket();
                  Get.snackbar(
                    'WebSocket Disconnected',
                    'Real-time updates stopped',
                    backgroundColor: Colors.orange,
                  );
                } else {
                  driverConfirmationController.connectWebSocket();
                  Get.snackbar(
                    'WebSocket Connecting',
                    'Attempting to connect...',
                    backgroundColor: Colors.blue,
                  );
                }
              },
              child: Icon(
                isConnected ? Icons.cloud_done : Icons.cloud_off,
                color: Colors.white,
              ),
              backgroundColor: isConnected ? Colors.green : Colors.red,
              mini: true,
              tooltip: isConnected ? 'Internet Connected' : 'Internet Disconnected',
            );
          }),

          // Location tracking status - FIXED: Use public method
          SizedBox(height: 10),
          Obx(() {
            final isTracking = driverConfirmationController.isLocationTracking.value;
            return FloatingActionButton(
              onPressed: () {
                if (isTracking) {
                  Get.snackbar(
                    'Location Tracking',
                    'Real-time location tracking is active',
                    backgroundColor: Colors.green,
                  );
                } else {
                  // Start location tracking manually
                  driverConfirmationController.startLocationTracking();
                }
              },
              child: Icon(
                isTracking ? Icons.location_on : Icons.location_off,
                color: Colors.white,
              ),
              backgroundColor: isTracking ? Colors.green : Colors.grey,
              mini: true,
              tooltip: isTracking ? 'Location Tracking Active' : 'Location Tracking Inactive',
            );
          }),
        ],
      ),
    );
  }

  Widget buildBottomSheet(int value) {
    final rideData = driverConfirmationController.currentRide;
    if (rideData == null) {
      print('No ride data for bottom sheet');
      return Container();
    }
    print('Building bottom sheet: $value');
    switch (value) {
      case 1:
        return BottomSheetOne(data: rideData);
      case 2:
        return BottomSheetTwo(data: rideData);
      case 3:
        return BottomSheetThree(data: rideData);
      case 4:
        return BottomSheetFour(data: rideData);
      case 5:
        return BottomSheetFive(data: rideData);
      case 6:
        return BottomSheetSix(data: rideData);
      case 7:
        return BottomSheetSeven(data: rideData);
      case 8:
        return BottomSheetEight(data: rideData);
      case 9:
        return BottomSheetNine(data: rideData);
      default:
        print('Invalid bottom sheet value: $value');
        return Container();
    }
  }

  @override
  void dispose() {
    // Clean up controllers if needed
    super.dispose();
  }
}