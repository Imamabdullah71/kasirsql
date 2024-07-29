import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/switch_controller/switch_controller.dart';


class TesttingPage extends StatelessWidget {
  const TesttingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SwitchController switchController = Get.find<SwitchController>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "TESTING PAGE",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Center(
        child: Obx(
          () => Switch(
            value: switchController.isSwitched.value,
            onChanged: switchController.toggleSwitch,
          ),
        ),
      ),
    );
  }
}
