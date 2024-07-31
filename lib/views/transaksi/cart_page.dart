import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/transaksi_controller/transaksi_controller.dart';
import 'package:kasirsql/models/barang_model.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final TransaksiController transaksiController = Get.find<TransaksiController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Obx(() => Text(
          'Total Harga: ${transaksiController.formatRupiah(transaksiController.totalHarga.value)}',
          style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        )),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
        elevation: 0,
      ),
      body: Obx(() {
        if (transaksiController.selectedBarangList.isEmpty) {
          return const Center(
            child: Text(
              'Keranjang kosong',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Barang: ${transaksiController.totalBarang.value}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: transaksiController.selectedBarangList.length,
                itemBuilder: (context, index) {
                  final detailBarang = transaksiController.selectedBarangList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: detailBarang['gambar'] != null && detailBarang['gambar'].isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'http://10.10.10.129/flutterapi/uploads/${detailBarang['gambar']}',
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            )
                          : const Icon(Icons.broken_image),
                      title: Text(
                        detailBarang['nama_barang'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${transaksiController.formatRupiah(detailBarang['harga_barang'])} x ${detailBarang['jumlah_barang']} = ${transaksiController.formatRupiah(detailBarang['jumlah_harga'])}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (detailBarang['jumlah_barang'] > 1) {
                                transaksiController.updateBarangQuantity(
                                  Barang(
                                    id: detailBarang['id'],
                                    namaBarang: detailBarang['nama_barang'],
                                    hargaJual: detailBarang['harga_barang'],
                                    kodeBarang: detailBarang['kode_barang'],
                                    stokBarang: detailBarang['stok_barang'],
                                    kategoriId: detailBarang['kategori_id'],
                                    namaKategori: detailBarang['nama_kategori'],
                                    hargaBeli: detailBarang['harga_beli'],
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    gambar: detailBarang['gambar'],
                                  ),
                                  detailBarang['jumlah_barang'] - 1,
                                );
                              } else {
                                transaksiController.removeBarangFromCart(
                                  Barang(
                                    id: detailBarang['id'],
                                    namaBarang: detailBarang['nama_barang'],
                                    hargaJual: detailBarang['harga_barang'],
                                    kodeBarang: detailBarang['kode_barang'],
                                    stokBarang: detailBarang['stok_barang'],
                                    kategoriId: detailBarang['kategori_id'],
                                    namaKategori: detailBarang['nama_kategori'],
                                    hargaBeli: detailBarang['harga_beli'],
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    gambar: detailBarang['gambar'],
                                  ),
                                );
                              }
                            },
                          ),
                          Text(
                            detailBarang['jumlah_barang'].toString(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              if (detailBarang['jumlah_barang'] < detailBarang['stok_barang']) {
                                transaksiController.updateBarangQuantity(
                                  Barang(
                                    id: detailBarang['id'],
                                    namaBarang: detailBarang['nama_barang'],
                                    hargaJual: detailBarang['harga_barang'],
                                    kodeBarang: detailBarang['kode_barang'],
                                    stokBarang: detailBarang['stok_barang'],
                                    kategoriId: detailBarang['kategori_id'],
                                    namaKategori: detailBarang['nama_kategori'],
                                    hargaBeli: detailBarang['harga_beli'],
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                    gambar: detailBarang['gambar'],
                                  ),
                                  detailBarang['jumlah_barang'] + 1,
                                );
                              } else {
                                Get.snackbar(
                                  'Stok Tidak Cukup',
                                  'Tidak bisa melebihi stok barang.',
                                  backgroundColor: const Color.fromARGB(255, 235, 218, 63),
                                  colorText: Colors.black,
                                  borderRadius: 10,
                                  margin: const EdgeInsets.all(10),
                                  snackPosition: SnackPosition.TOP,
                                  icon: const Icon(Icons.error, color: Colors.black),
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
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 114, 94, 225),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () => Get.toNamed("/payment_page"),
            child: Text(
              'Lanjut ke Pembayaran (${transaksiController.totalBarang.value})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          );
        }),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
