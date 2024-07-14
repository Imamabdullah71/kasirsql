import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/views/transaksi/cart_page.dart';
import 'package:kasirsql/views/transaksi/transaksi_page.dart';

class TransactionSuccessPage extends StatelessWidget {
  const TransactionSuccessPage({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Transaksi Berhasil Dilakukan!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.offAll(() => TransaksiPage());
              },
              child: const Text('Halaman Utama'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.offAll(() => CartPage());
              },
              child: const Text('Transaksi Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
