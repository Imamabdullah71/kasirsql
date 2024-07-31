import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller/rupiah_input_formatter.dart';
import 'package:kasirsql/controllers/hutang_controller/hutang_controller.dart';
import 'package:kasirsql/controllers/switch_controller/switch_controller.dart';
import 'package:kasirsql/controllers/transaksi_controller/transaksi_controller.dart';

class PaymentPage extends StatelessWidget {
  PaymentPage({super.key});
  final TransaksiController transaksiController =
      Get.find<TransaksiController>();
  final TextEditingController uangDibayarController = TextEditingController();
  final TextEditingController daftarController =
      TextEditingController(); // Controller untuk nama penghutang
  final SwitchController switchController = Get.find<SwitchController>();
  final HutangController hutangController = Get.find<HutangController>();

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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              return Text(
                'Total Harga: ${transaksiController.formatRupiah(transaksiController.totalHarga.value)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
            const SizedBox(height: 16),
            TextFormField(
              controller: uangDibayarController,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                labelText: 'Uang Dibayar',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 114, 94, 225),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RupiahInputFormatter(),
              ],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pembayaran tidak boleh kosong';
                }
                if (double.tryParse(value.replaceAll('.', '')) == null) {
                  return 'Pembayaran harus berupa angka';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Obx(
              () => Row(
                children: [
                  Switch(
                    value: switchController.isSwitched.value,
                    onChanged: switchController.toggleSwitch,
                  ),
                  const SizedBox(width: 5),
                  const Text("Hutang"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () {
                if (switchController.isSwitched.value) {
                  return TextFormField(
                    controller: daftarController,
                    decoration: InputDecoration(
                      labelText: 'Nama penghutang',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 114, 94, 225),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            const SizedBox(height: 20),
            Obx(
              () {
                return Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 114, 94, 225),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (switchController.isSwitched.value) {
                        masukkanKeDaftar();
                      } else {
                        bayar();
                      }
                    },
                    child: Text(
                      switchController.isSwitched.value
                          ? 'Masukkan ke daftar'
                          : 'Bayar',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void bayar() {
    transaksiController.bayar.value =
        double.parse(uangDibayarController.text.replaceAll('.', ''));
    transaksiController.kembali.value =
        transaksiController.bayar.value - transaksiController.totalHarga.value;
    transaksiController.createTransaksi();
  }

  void masukkanKeDaftar() async {
    transaksiController.bayar.value =
        double.parse(uangDibayarController.text.replaceAll('.', ''));
    transaksiController.kembali.value =
        transaksiController.bayar.value - transaksiController.totalHarga.value;

    var transaksiId = await transaksiController.createTransaksiWithNoReceipt();
    if (transaksiId != null) {
      transaksiController.createHutang(
        transaksiId,
        daftarController.text,
        transaksiController.bayar.value - transaksiController.totalHarga.value,
      );
    }
  }
}
