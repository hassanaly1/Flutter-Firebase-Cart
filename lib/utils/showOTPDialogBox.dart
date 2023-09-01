import 'package:flutter/material.dart';

void showOTPDialog({
  required BuildContext context,
  required TextEditingController codeController,
  required VoidCallback onPressed,
}) {
  showDialog(
    context: context,
    //Did not dismissal the Alertbox when when user taps outside the box.
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Enter OTP"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: codeController,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: const Text("Done"),
        )
      ],
    ),
  );
}
