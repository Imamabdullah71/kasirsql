import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/transaksi_controller/transaksi_controller.dart';
import 'package:kasirsql/models/barang_model.dart';
import 'package:kasirsql/views/transaksi/payment_page.dart';

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
        title: const Text(
          "Keranjang",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Obx(() {
        if (transaksiController.selectedBarangList.isEmpty) {
          return const Center(child: Text('Keranjang kosong'));
        }
        return ListView.builder(
          itemCount: transaksiController.selectedBarangList.length,
          itemBuilder: (context, index) {
            final detailBarang = transaksiController.selectedBarangList[index];
            return ListTile(
              title: Text(detailBarang['nama']),
              subtitle: Text('${detailBarang['harga']} x ${detailBarang['jumlah']} = ${detailBarang['jumlah_harga']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (detailBarang['jumlah'] > 1) {
                        transaksiController.updateBarangQuantity(
                          Barang(
                            id: detailBarang['id'],
                            namaBarang: detailBarang['nama'],
                            hargaJual: detailBarang['harga'],
                            kodeBarang: detailBarang['kode_barang'],
                            stokBarang: detailBarang['stok_barang'],
                            kategoriId: detailBarang['kategori_id'],
                            namaKategori: detailBarang['nama_kategori'],
                            hargaBeli: detailBarang['harga_beli'],
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                          detailBarang['jumlah'] - 1,
                        );
                      } else {
                        transaksiController.removeBarangFromCart(
                          Barang(
                            id: detailBarang['id'],
                            namaBarang: detailBarang['nama'],
                            hargaJual: detailBarang['harga'],
                            kodeBarang: detailBarang['kode_barang'],
                            stokBarang: detailBarang['stok_barang'],
                            kategoriId: detailBarang['kategori_id'],
                            namaKategori: detailBarang['nama_kategori'],
                            hargaBeli: detailBarang['harga_beli'],
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          ),
                        );
                      }
                    },
                  ),
                  Text(detailBarang['jumlah'].toString()),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      transaksiController.updateBarangQuantity(
                        Barang(
                          id: detailBarang['id'],
                          namaBarang: detailBarang['nama'],
                          hargaJual: detailBarang['harga'],
                          kodeBarang: detailBarang['kode_barang'],
                          stokBarang: detailBarang['stok_barang'],
                          kategoriId: detailBarang['kategori_id'],
                          namaKategori: detailBarang['nama_kategori'],
                          hargaBeli: detailBarang['harga_beli'],
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        ),
                        detailBarang['jumlah'] + 1,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => PaymentPage());
          },
          child: const Text('Lanjut ke Pembayaran'),
        ),
      ),
    );
  }
}
