import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasirsql/controllers/hutang_controller/hutang_controller.dart';
import 'package:kasirsql/models/hutang_model.dart';
import 'package:kasirsql/views/hutang/lunas_page.dart';
import 'package:kasirsql/views/hutang/riwayat_bayar_page.dart';

class HutangPage extends StatelessWidget {
  final HutangController hutangController = Get.put(HutangController());

  HutangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Hutang",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Get.to(() => LunasPage()),
          )
        ],
      ),
      body: Obx(() {
        if (hutangController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: hutangController.hutangList.length,
          itemBuilder: (context, index) {
            var hutang = hutangController.hutangList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  title: Text(
                    formatTanggal(hutang.tanggalMulai),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Sisa Hutang: ${formatRupiah(hutang.sisaHutang)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () => _showDetailDialog(context, hutang),
                ),
              ),
            );
          },
        );
      }),
      backgroundColor: Colors.white,
    );
  }

  void _showDetailDialog(BuildContext context, Hutang hutang) {
    final TextEditingController inputBayarController = TextEditingController();
    final RxBool isPressed = false.obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detail Hutang'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nama: ${hutang.nama}'),
              Text('Sisa Hutang: ${formatRupiah(hutang.sisaHutang)}'),
              Text('Tanggal Mulai: ${formatTanggal(hutang.tanggalMulai)}'),
              const SizedBox(height: 5),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: inputBayarController,
                decoration: InputDecoration(
                  labelText: 'Input Bayar',
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
              ),
            ],
          ),
          actions: [
            Center(
              child: Obx(() {
                return GestureDetector(
                  onTapDown: (_) {
                    isPressed.value = true;
                  },
                  onTapUp: (_) async {
                    isPressed.value = false;
                    double inputBayar =
                        double.tryParse(inputBayarController.text) ?? 0.0;
                    double sisaHutangSebelum = hutang.sisaHutang;
                    double sisaHutangSekarang = sisaHutangSebelum + inputBayar;

                    if (inputBayar <= sisaHutangSebelum.abs()) {
                      await hutangController.updateHutang(hutang.id!,
                          inputBayar, sisaHutangSebelum, hutang.transaksiId);
                      if (!context.mounted) return;
                      if (sisaHutangSekarang == 0) {
                        hutangController.updateStatusHutang(
                            hutang.id!, 'lunas');
                      }
                      Get.back();
                    } else {
                      double kembali = inputBayar - sisaHutangSebelum.abs();
                      sisaHutangSekarang = 0;
                      await hutangController.updateHutang(hutang.id!,
                          inputBayar, sisaHutangSebelum, hutang.transaksiId);
                      hutangController.updateStatusHutang(hutang.id!, 'lunas');
                      if (!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Kembali'),
                            content: Text('Kembali: $kembali'),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                  Get.back();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: isPressed.value
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
                      'Bayar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 5),
            Center(
              child: Obx(() {
                return GestureDetector(
                  onTapDown: (_) {
                    isPressed.value = true;
                  },
                  onTapUp: (_) {
                    isPressed.value = false;
                    Get.to(() => RiwayatBayarPage(hutangId: hutang.id!));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: isPressed.value
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
                      'Riwayat Bayar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  String formatTanggal(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(date);
  }

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }
}
