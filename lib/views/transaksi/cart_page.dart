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
          style: const TextStyle(fontSize: 20, color: Colors.white),
        )),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Obx(() {
        if (transaksiController.selectedBarangList.isEmpty) {
          return const Center(child: Text('Keranjang kosong'));
        }
        return Column(
          children: [
            Text('Total Barang: ${transaksiController.totalBarang.value}'), // Tampilkan totalBarang
            Expanded(
              child: ListView.builder(
                itemCount: transaksiController.selectedBarangList.length,
                itemBuilder: (context, index) {
                  final detailBarang = transaksiController.selectedBarangList[index];
                  return ListTile(
                    leading: detailBarang['gambar'] != null && detailBarang['gambar']!.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'http://10.10.10.129/flutterapi/uploads/${detailBarang['gambar']}',
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                    title: Text(detailBarang['nama_barang']),
                    subtitle: Text(
                      '${transaksiController.formatRupiah(detailBarang['harga_barang'])} x ${detailBarang['jumlah_barang']} = ${transaksiController.formatRupiah(detailBarang['jumlah_harga'])}'
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
                                ),
                              );
                            }
                          },
                        ),
                        Text(detailBarang['jumlah_barang'].toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
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
                              ),
                              detailBarang['jumlah_barang'] + 1,
                            );
                          },
                        ),
                      ],
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
            onPressed: () => Get.toNamed("/payment_page"),
            child: Text('Lanjut ke Pembayaran (${transaksiController.totalBarang.value})'),
          );
        }),
      ),
    );
  }
}
