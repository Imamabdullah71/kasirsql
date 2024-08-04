import 'package:bootstrap_icons/bootstrap_icons.dart';
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
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Pembayaran",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Obx(() {
                return Column(
                  children: [
                    const Text(
                      'Total Harga',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp ${transaksiController.formatRupiah(transaksiController.totalHarga.value)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),
            Obx(() => TextFormField(
                  keyboardType: TextInputType.number,
                  controller: uangDibayarController,
                  decoration: InputDecoration(
                    prefixText: 'Rp ',
                    labelText: switchController.isSwitched.value
                        ? 'Uang yang baru dibayar'
                        : 'Uang dibayar',
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 114, 94, 225),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade500,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: const EdgeInsets.only(left: 20),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    RupiahInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pembayaran tidak boleh kosong';
                    }
                    double? jumlah = double.tryParse(value.replaceAll('.', ''));
                    if (jumlah == null) {
                      return 'Pembayaran harus berupa angka';
                    }
                    if (switchController.isSwitched.value &&
                        jumlah >= transaksiController.totalHarga.value) {
                      return 'Pembayaran harus lebih rendah dari total harga';
                    }
                    return null;
                  },
                )),
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
            Obx(() {
              if (switchController.isSwitched.value) {
                return TextFormField(
                  keyboardType: TextInputType.text,
                  controller: daftarController,
                  decoration: InputDecoration(
                    labelText: 'Nama penghutang',
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 114, 94, 225),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade500,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    contentPadding: const EdgeInsets.only(left: 20),
                  ),
                );
              } else {
                return Container();
              }
            }),
            const SizedBox(height: 20),
            Obx(
              () {
                return Center(
                  child: InkWell(
                    onTap: () {
                      if (switchController.isSwitched.value) {
                        masukkanKeDaftar(context);
                      } else {
                        bayar();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 229, 135, 246),
                            Color.fromARGB(255, 114, 94, 225),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      child: Center(
                        child: Text(
                          switchController.isSwitched.value
                              ? 'Masukkan ke hutang'
                              : 'Bayar',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
    double bayar = double.parse(uangDibayarController.text.replaceAll('.', ''));
    double totalHarga = transaksiController.totalHarga.value;

    if (bayar < totalHarga) {
      Get.snackbar(
        'Peringatan',
        'Uang harus lebih tinggi dari total harga.',
        backgroundColor: const Color.fromARGB(255, 235, 218, 63),
        colorText: Colors.black,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(BootstrapIcons.exclamation_triangle_fill,
            color: Colors.black),
        duration: const Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      );
      Get.snackbar(
        'Peringatan',
        'Uang dibayar kurang harus dimasukkan ke hutang.',
        backgroundColor: const Color.fromARGB(255, 235, 218, 63),
        colorText: Colors.black,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(BootstrapIcons.exclamation_triangle_fill,
            color: Colors.black),
        duration: const Duration(seconds: 2),
        snackStyle: SnackStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      );
    } else {
      transaksiController.bayar.value = bayar;
      transaksiController.kembali.value = bayar - totalHarga;
      transaksiController.createTransaksi();
    }
  }

  void masukkanKeDaftar(BuildContext context) async {
    double jumlahBayar =
        double.parse(uangDibayarController.text.replaceAll('.', ''));
    if (jumlahBayar >= transaksiController.totalHarga.value) {
      // Tampilkan pesan error

      Get.snackbar(
        'Peringatan Hutang',
        'Uang harus lebih rendah dari total harga.',
        backgroundColor: const Color.fromARGB(255, 235, 218, 63),
        colorText: Colors.black,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(BootstrapIcons.exclamation_triangle_fill,
            color: Colors.black),
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      );

      return; // Hentikan eksekusi fungsi
    }

    transaksiController.bayar.value = jumlahBayar;
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
