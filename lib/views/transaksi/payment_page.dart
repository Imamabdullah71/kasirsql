import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/transaksi_controller/transaksi_controller.dart';

class PaymentPage extends StatelessWidget {
  PaymentPage({super.key});
  final TransaksiController transaksiController = Get.find<TransaksiController>();
  final TextEditingController uangDibayarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Pembayaran",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Total Harga: ${transaksiController.totalHarga}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: uangDibayarController,
              decoration: const InputDecoration(labelText: 'Uang Dibayar'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                transaksiController.bayar.value = double.parse(uangDibayarController.text);
                transaksiController.kembali.value = transaksiController.bayar.value - transaksiController.totalHarga.value;
                transaksiController.createTransaksi();
              },
              child: const Text('Bayar'),
            ),
          ],
        ),
      ),
    );
  }
}
