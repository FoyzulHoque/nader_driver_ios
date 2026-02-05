import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  const NoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Searching for the client, please wait",
          style: TextStyle(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        Icon(Icons.location_on_outlined, size: 200, color: Colors.yellow[700]),

        const SizedBox(height: 40),

        const Text(
          "Looking for Rider",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 24),

        Expanded(
          child: Center(
            child: Image.asset(
              "assets/images/rider.png",
              width: 278,
              height: 185,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
