import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/bottom_bar_controller.dart';

class TransactionSuccessPage extends StatelessWidget {
  final File receiptFile;
  const TransactionSuccessPage({super.key, required this.receiptFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Transaksi Berhasil",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Transaksi Berhasil Dilakukan!',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              receiptFile.existsSync()
                  ? Image.file(receiptFile)
                  : const Text('Receipt tidak ditemukan'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final BottomBarController bottomBarController = Get.find();
                  bottomBarController.resetToHome(); // Reset to Home page
                  Get.offAllNamed('/halaman_utama');
                },
                child: const Text('Halaman Utama'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back();
                },
                child: const Text('Transaksi Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
