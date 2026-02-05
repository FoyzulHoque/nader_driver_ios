import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/global_widegts/currency_formatter.dart';
import '../controller/wallet_controller.dart';
import 'package:intl/intl.dart';



class WalletScreen extends StatelessWidget {
  WalletScreen({super.key});


  final DriverIncomeController driverIncomeController = Get.put(DriverIncomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back(); // Navigate back to the previous screen
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 24,
          ),
        ),

        title: const Text(
          "Wallet",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your balance ", style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),),
            SizedBox(height: 16,),

            /// Balance Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey.shade100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final formattedIncome = NumberFormat("#,##0", "en_US")
                        .format(driverIncomeController.totalIncome.value);

                    return Text(
                      "$formattedIncome ل.ل",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => Column(
                        children: [
                          const Text("Duration",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text("${driverIncomeController.totalDuration.value} m",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      )),
                      Container(
                        height: 50,
                        width: 2,
                        color: Colors.grey.shade400,
                      ),

                      Obx(() => Column(
                        children: [
                          const Text("Distance",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 14)),
                          const SizedBox(height: 4),
                          Text("${driverIncomeController.totalDistance.value.toStringAsFixed(2)} km",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ],
                      )),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// Transaction History Title
            const Text(
              "Transaction History",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            /// Transaction List
            Expanded(
              child: Obx(() => ListView.separated(
                itemCount: driverIncomeController.transactionHistory.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = driverIncomeController.transactionHistory[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(item.userAvatar),
                          radius: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.userName.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              const SizedBox(height: 4),
                              Text(
                                "${item.rideTime} min   ${item.distance.toStringAsFixed(2)} km",//item.rideTime.toString(),
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Cash",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(CurrencyFormatter.format(item.totalAmount),
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}
