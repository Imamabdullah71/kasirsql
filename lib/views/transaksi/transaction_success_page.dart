import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart'; // Import Lottie package
import 'package:kasirsql/controllers/bottom_bar_controller.dart';
import 'package:kasirsql/controllers/transaksi_controller/transaksi_controller.dart';

class TransactionSuccessPage extends StatelessWidget {
  final File receiptFile;
  final TransaksiController transaksiController =
      Get.find<TransaksiController>();
  final RxBool showReceipt = false.obs;

  TransactionSuccessPage({super.key, required this.receiptFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Transaksi Berhasil",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
        actions: [
          IconButton(
              onPressed: () {
                final BottomBarController bottomBarController = Get.find();
                bottomBarController.resetToHome(); // Reset to Home page
                Get.offAllNamed('/halaman_utama');
              },
              icon: const Icon(Icons.home))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add Lottie animation
              Lottie.asset(
                'assets/lotties/success.json',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                'Transaksi berhasil !',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              Obx(() {
                return showReceipt.value
                    ? receiptFile.existsSync()
                        ? Image.file(receiptFile)
                        : const Text('Receipt tidak ditemukan')
                    : Container(); // Placeholder when receipt is not shown
              }),
              const SizedBox(height: 16),
              Center(
                child: Obx(() {
                  return GestureDetector(
                    onTapDown: (_) {
                      transaksiController.toggleButtonPress();
                    },
                    onTapUp: (_) {
                      transaksiController.toggleButtonPress();
                      showReceipt.value =
                          !showReceipt.value; // Toggle the receipt visibility
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: transaksiController.isPressed.value
                            ? const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 229, 135, 246),
                                  Color.fromARGB(255, 114, 94, 225),
                                ],
                              )
                            : const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 114, 94, 225),
                                  Color.fromARGB(255, 229, 135, 246),
                                ],
                              ),
                      ),
                      child: Text(
                        showReceipt.value
                            ? 'Sembunyikan Struk'
                            : 'Tampilkan Struk',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Center(
                child: Obx(() {
                  return GestureDetector(
                    onTapDown: (_) {
                      transaksiController.toggleButtonPress();
                    },
                    onTapUp: (_) {
                      transaksiController.toggleButtonPress();
                      final BottomBarController bottomBarController =
                          Get.find();
                      bottomBarController.resetToHome(); // Reset to Home page
                      Get.offAllNamed('/halaman_utama');
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: transaksiController.isPressed.value
                            ? const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 229, 135, 246),
                                  Color.fromARGB(255, 114, 94, 225),
                                ],
                              )
                            : const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 114, 94, 225),
                                  Color.fromARGB(255, 229, 135, 246),
                                ],
                              ),
                      ),
                      child: const Text(
                        'Halaman Utama',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
