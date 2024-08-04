import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/transaksi_controller/transaksi_controller.dart';
import 'package:kasirsql/models/barang_model.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final TransaksiController transaksiController =
      Get.find<TransaksiController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Keranjang",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0, // Add this line to set the shadow
        shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
      ),
      body: Obx(() {
        if (transaksiController.selectedBarangList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 229, 135, 246),
                        Color.fromARGB(255, 114, 94, 225),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Icon(
                    BootstrapIcons.cart3,
                    size: 80,
                    color: Colors
                        .white, // Warna dasar ikon harus diatur menjadi putih
                  ),
                ),
                const Text(
                  'Keranjang kosong',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total Barang: ${transaksiController.totalBarang.value}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: transaksiController.selectedBarangList.length,
                itemBuilder: (context, index) {
                  final detailBarang =
                      transaksiController.selectedBarangList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: detailBarang['gambar'] != null &&
                              detailBarang['gambar'].isNotEmpty
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
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${transaksiController.formatRupiah(detailBarang['harga_barang'])} x ${detailBarang['jumlah_barang']} = ${transaksiController.formatRupiah(detailBarang['jumlah_harga'])}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
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
                                    barcodeBarang:
                                        detailBarang['barcode_barang'],
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
                                    barcodeBarang:
                                        detailBarang['barcode_barang'],
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
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              if (detailBarang['jumlah_barang'] <
                                  detailBarang['stok_barang']) {
                                transaksiController.updateBarangQuantity(
                                  Barang(
                                    id: detailBarang['id'],
                                    namaBarang: detailBarang['nama_barang'],
                                    hargaJual: detailBarang['harga_barang'],
                                    barcodeBarang:
                                        detailBarang['barcode_barang'],
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
                                  backgroundColor:
                                      const Color.fromARGB(255, 235, 218, 63),
                                  colorText: Colors.black,
                                  borderRadius: 10,
                                  margin: const EdgeInsets.all(10),
                                  snackPosition: SnackPosition.TOP,
                                  icon: const Icon(Icons.error,
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
        child: InkWell(
          onTap: () => Get.toNamed("/payment_page"),
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
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  BootstrapIcons.wallet,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Obx(() {
                  return Text(
                    '(Rp ${transaksiController.formatRupiah(transaksiController.totalHarga.value)})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Obx(() {
      //     return ElevatedButton(
      //       style: ElevatedButton.styleFrom(
      //         backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      //         padding: const EdgeInsets.symmetric(vertical: 15),
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(30.0),
      //         ),
      //       ),
      //       onPressed: () => Get.toNamed("/payment_page"),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           const Icon(
      //             BootstrapIcons.wallet,
      //             color: Colors.white,
      //           ),
      //           const SizedBox(
      //             width: 5,
      //           ),
      //           Text(
      //             'Pembayaran (${transaksiController.formatRupiah(transaksiController.totalHarga.value)})',
      //             style: const TextStyle(
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.white),
      //           ),
      //         ],
      //       ),
      //     );
      //   }),
      // ),
      backgroundColor: Colors.grey[100],
    );
  }
}
