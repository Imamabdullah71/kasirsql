import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/switch_controller/switch_controller.dart';

class TesttingPage extends StatelessWidget {
  const TesttingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SwitchController switchController = Get.find<SwitchController>();

    // Tambahkan controller untuk mengatur tampilan CircularProgressIndicator
    final RxBool isLoading = false.obs;

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Switch(
                value: switchController.isSwitched.value,
                onChanged: switchController.toggleSwitch,
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  isLoading.value = !isLoading.value;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 114, 94, 225),
                ),
                child: const Text("Tampilkan Loading"),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => isLoading.value
                  ? CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                      backgroundColor: Colors.purple.shade200,
                      strokeWidth: 6.0,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}