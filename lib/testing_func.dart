import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestingFunc extends StatelessWidget {
  const TestingFunc({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.defaultDialog(
              title: 'Loading...',
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Proses login sedang berlangsung'),
                ],
              ),
              barrierDismissible: false,
              textConfirm: 'ok',
              onConfirm: () => Get.back(),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 114, 94, 225),
            minimumSize: const Size(double.infinity, 48),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          child: const Text(
            "TEST",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
