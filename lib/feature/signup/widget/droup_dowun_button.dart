// Helper widget for text fields
import "package:flutter/material.dart";

Widget buildBox(TextEditingController controller) {
  return Container(
    height: 55,
    width: 55,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      controller: controller,
      textAlign: TextAlign.center,
      decoration: InputDecoration(border: InputBorder.none),
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  );
}
