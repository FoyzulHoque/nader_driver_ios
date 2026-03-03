import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/confirmArrivelController.dart';
import '../controller/driver_confirmation_controller.dart';
import '../controller/rider_info_api_controller.dart';
import '../model/online_ride_model.dart';

class BottomSheetFour extends StatefulWidget {
  final OnlineRideModel data;
  const BottomSheetFour({super.key, required this.data});

  @override
  State<BottomSheetFour> createState() => _BottomSheetFourState();
}

class _BottomSheetFourState extends State<BottomSheetFour> {
  final DriverConfirmationController controller =
      Get.find<DriverConfirmationController>();

  final ConfirmArrivelController confirmArrivelController = Get.put(
    ConfirmArrivelController(),
  );
  final RiderInfoApiController riderInfoApiController =
      Get.find<RiderInfoApiController>();

  @override
  void initState() {
    // TODO: implement initState
    riderInfoApiController.riderInfoApiMethod(widget.data.id ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.30,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle bar
                        Container(
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Customer arrived Confirmation",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "The customer arrived",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        /// Confirm button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              confirmArrivelController.confirmArrival(
                                carTransportId: widget.data.id ?? 'unknown',
                              ); // Handle nullable id
                              controller.changeSheet(5);
                            },
                            child: Text(
                              "Arrival Confirmed",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
