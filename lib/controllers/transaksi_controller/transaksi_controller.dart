import 'dart:convert';
import 'dart:io';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kasirsql/controllers/bottom_bar_controller.dart';
import 'package:kasirsql/controllers/transaksi_controller/generate_receipt_controller.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/transaksi_model.dart';
import 'package:kasirsql/models/barang_model.dart';
import 'package:kasirsql/models/detail_transaksi_model.dart';
import 'package:kasirsql/models/hutang_model.dart'; // Import model hutang
import 'package:kasirsql/views/transaksi/transaction_success_page.dart';
import 'package:path_provider/path_provider.dart';

class TransaksiController extends GetxController {
  var isPressed = false.obs;
  var isLoading = false.obs;
  var selectedBarangList = <Map<String, dynamic>>[].obs;
  var totalHarga = 0.0.obs;
  var totalHargaBeli = 0.0.obs;
  var totalBarang = 0.obs;
  var bayar = 0.0.obs;
  var kembali = 0.0.obs;
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_transaksi.php';
  final UserController userController = Get.find<UserController>();

  void addBarangToCart(Barang barang) {
    var existingBarangIndex =
        selectedBarangList.indexWhere((element) => element['id'] == barang.id);

    if (existingBarangIndex == -1) {
      if (barang.stokBarang > 0) {
        selectedBarangList.add({
          'id': barang.id,
          'gambar': barang.gambar,
          'nama_barang': barang.namaBarang,
          'harga_barang': barang.hargaJual,
          'jumlah_barang': 1,
          'jumlah_harga': barang.hargaJual,
          'kode_barang': barang.kodeBarang,
          'stok_barang': barang.stokBarang,
          'kategori_id': barang.kategoriId,
          'nama_kategori': barang.namaKategori,
          'harga_beli': barang.hargaBeli,
        });
        totalHarga.value += barang.hargaJual;
        totalHargaBeli.value += barang.hargaBeli;
        _updateTotalBarang();
        selectedBarangList.refresh();
      } else {
        // Peringatan
        Get.snackbar(
          'Stok Tidak Cukup',
          'Tidak bisa melebihi stok barang.',
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
      }
    } else {
      var existingBarang = selectedBarangList[existingBarangIndex];
      if (existingBarang['jumlah_barang'] < barang.stokBarang) {
        existingBarang['jumlah_barang'] += 1;
        existingBarang['jumlah_harga'] =
            existingBarang['jumlah_barang'] * existingBarang['harga_barang'];
        selectedBarangList[existingBarangIndex] = existingBarang;

        totalHarga.value += barang.hargaJual;
        totalHargaBeli.value += barang.hargaBeli;
        _updateTotalBarang();
        selectedBarangList.refresh();
      } else {
        Get.snackbar(
          'Stok Tidak Cukup',
          'Tidak bisa melebihi stok barang.',
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
      }
    }

    print('Total Barang: ${totalBarang.value}');
  }

  void removeBarangFromCart(Barang barang) {
    var detailBarang =
        selectedBarangList.firstWhere((element) => element['id'] == barang.id);
    selectedBarangList.remove(detailBarang);
    totalHarga.value -= barang.hargaJual;
    totalHargaBeli.value -= barang.hargaBeli;
    _updateTotalBarang();
    selectedBarangList.refresh();
    print('Total Barang: ${totalBarang.value}');
  }

  void updateBarangQuantity(Barang barang, int quantity) {
    var detailBarang =
        selectedBarangList.firstWhere((element) => element['id'] == barang.id);

    if (quantity > barang.stokBarang) {
      Get.snackbar(
        'Stok Tidak Cukup',
        'Tidak bisa melebihi stok barang.',
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
      return;
    }

    totalHarga.value -=
        detailBarang['harga_barang'] * detailBarang['jumlah_barang'];
    totalHargaBeli.value -=
        detailBarang['harga_beli'] * detailBarang['jumlah_barang'];
    detailBarang['jumlah_barang'] = quantity;
    detailBarang['jumlah_harga'] =
        detailBarang['harga_barang'] * detailBarang['jumlah_barang'];
    totalHarga.value +=
        detailBarang['harga_barang'] * detailBarang['jumlah_barang'];
    totalHargaBeli.value +=
        detailBarang['harga_beli'] * detailBarang['jumlah_barang'];
    _updateTotalBarang();
    selectedBarangList.refresh();
    print('Total Barang: ${totalBarang.value}');
  }

  void _updateTotalBarang() {
    totalBarang.value = selectedBarangList.fold<int>(
        0, (sum, item) => sum + item['jumlah_barang'] as int);
  }

  Future<void> createTransaksi() async {
    var now = DateTime.now();
    var userId = userController.currentUser.value?.id;

    if (userId == null) {
      // Peringatan
      Get.snackbar(
        'Stok Tidak Cukup',
        'User tidak ditemukan. Silakan login kembali.',
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
      return;
    }

    var transaksi = Transaksi(
      totalBarang: totalBarang.value,
      totalHarga: totalHarga.value,
      totalHargaBeli: totalHargaBeli.value,
      bayar: bayar.value,
      kembali: bayar.value - totalHarga.value,
      userId: userId,
      createdAt: now,
      updatedAt: now,
    );

    print(jsonEncode(transaksi.toJson()));

    try {
      isLoading.value = true;
      Get.defaultDialog(
        title: 'Loading...',
        content: const Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Proses transaksi sedang berlangsung'),
          ],
        ),
        barrierDismissible: false,
      );

      var response = await http.post(
        Uri.parse('$apiUrl?action=create_transaksi'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(transaksi.toJson()),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['status'] == 'success') {
          Get.snackbar(
            'Success',
            'Transaksi berhasil dilakukan',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.check_circle, color: Colors.white),
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

          print('RESPON: ${response.body}');

          var transaksiId = result['transaksi_id'];
          if (transaksiId != null) {
            await _saveDetailTransaksi(transaksiId);

            List<DetailTransaksi> detailTransaksiList =
                selectedBarangList.map((barang) {
              return DetailTransaksi(
                transaksiId: transaksiId,
                namaBarang: barang['nama_barang'],
                jumlahBarang: barang['jumlah_barang'],
                hargaBarang: barang['harga_barang'],
                jumlahHarga: barang['jumlah_harga'],
                createdAt: now,
                updatedAt: now,
              );
            }).toList();

            await Get.find<GenerateReceiptController>()
                .generateReceipt(transaksi, detailTransaksiList, transaksiId);

            String formattedDate =
                DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
            File receiptFile = File(
                '${(await getApplicationDocumentsDirectory()).path}/$formattedDate.png');

            var uri = Uri.parse('$apiUrl?action=upload_struk');
            var request = http.MultipartRequest('POST', uri)
              ..fields['transaksi_id'] = transaksiId.toString()
              ..files.add(
                  await http.MultipartFile.fromPath('struk', receiptFile.path));

            var uploadResponse = await request.send();
            if (uploadResponse.statusCode == 200) {
              var responseData = await uploadResponse.stream.bytesToString();
              var uploadResult = json.decode(responseData);
              if (uploadResult['status'] == 'success') {
                Get.to(() => TransactionSuccessPage(receiptFile: receiptFile));
              } else {
                // Gagal / Error
                Get.snackbar(
                  'Error',
                  'Gagal mengunggah struk',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  borderRadius: 10,
                  margin: const EdgeInsets.all(10),
                  snackPosition: SnackPosition.TOP,
                  icon: const Icon(Icons.error, color: Colors.white),
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
            } else {
              Get.snackbar(
                'Error',
                'Gagal mengunggah struk',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                borderRadius: 10,
                margin: const EdgeInsets.all(10),
                snackPosition: SnackPosition.TOP,
                icon: const Icon(Icons.error, color: Colors.white),
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
          } else {
            // Gagal / Error
            Get.snackbar(
              'Error',
              'Transaksi ID tidak ditemukan',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 10,
              margin: const EdgeInsets.all(10),
              snackPosition: SnackPosition.TOP,
              icon: const Icon(Icons.error, color: Colors.white),
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
        } else {
          // Gagal / Error
          Get.snackbar(
            'Error',
            'Transaksi gagal',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.error, color: Colors.white),
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
      } else {
        // Gagal / Error
        Get.snackbar(
          'Error',
          'Transaksi gagal',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.error, color: Colors.white),
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Transaksi gagal',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
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
    } finally {
      isLoading.value = false;
      Get.back();
    }
  }

  Future<void> _saveDetailTransaksi(int transaksiId) async {
    for (var barang in selectedBarangList) {
      var detailTransaksi = DetailTransaksi(
        transaksiId: transaksiId,
        namaBarang: barang['nama_barang'],
        jumlahBarang: barang['jumlah_barang'],
        hargaBarang: barang['harga_barang'],
        jumlahHarga: barang['jumlah_harga'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        var response = await http.post(
          Uri.parse('$apiUrl?action=create_detail_transaksi'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(detailTransaksi.toJson()),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to save detail transaksi');
        }

        var updateStockResponse = await http.post(
          Uri.parse('$apiUrl?action=update_stok_barang'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'id': barang['id'],
            'jumlah_barang': barang['jumlah_barang'],
          }),
        );

        if (updateStockResponse.statusCode != 200) {
          throw Exception('Failed to update stock');
        }
      } catch (e) {
        // Gagal / Error
        Get.snackbar(
          'Error',
          '$e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.error, color: Colors.white),
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
    }
  }

  // Fungsi createTransaksiWithNoReceipt diubah untuk mengembalikan transaksiId
  Future<int?> createTransaksiWithNoReceipt() async {
    var now = DateTime.now();
    var userId = userController.currentUser.value?.id;

    if (userId == null) {
      // Peringatan
      Get.snackbar(
        'Stok Tidak Cukup',
        'User tidak ditemukan. Silakan login kembali.',
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
      return null;
    }

    var transaksi = Transaksi(
      totalBarang: totalBarang.value,
      totalHarga: totalHarga.value,
      totalHargaBeli: totalHargaBeli.value,
      bayar: bayar.value,
      kembali: bayar.value - totalHarga.value,
      userId: userId,
      createdAt: now,
      updatedAt: now,
    );

    print(jsonEncode(transaksi.toJson()));

    try {
      isLoading.value = true;
      Get.defaultDialog(
        title: 'Loading...',
        content: const Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Proses transaksi sedang berlangsung'),
          ],
        ),
        barrierDismissible: false,
      );
      var response = await http.post(
        Uri.parse('$apiUrl?action=create_transaksi'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(transaksi.toJson()),
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['status'] == 'success') {
          Get.snackbar(
            'Success',
            'Transaksi berhasil dilakukan',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.check_circle, color: Colors.white),
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

          var transaksiId = result['transaksi_id'];
          if (transaksiId != null) {
            await _saveDetailTransaksi(transaksiId);

            selectedBarangList.map((barang) {
              return DetailTransaksi(
                transaksiId: transaksiId,
                namaBarang: barang['nama_barang'],
                jumlahBarang: barang['jumlah_barang'],
                hargaBarang: barang['harga_barang'],
                jumlahHarga: barang['jumlah_harga'],
                createdAt: now,
                updatedAt: now,
              );
            }).toList();

            isLoading.value = false;
            Get.back();

            Get.defaultDialog(
              title: 'Berhasil memasukkan ke laporan hutang!',
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 229, 135, 246),
                          Color.fromARGB(255, 114, 94, 225),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        final BottomBarController bottomBarController =
                            Get.find();
                        bottomBarController.resetToHome();
                        Get.offAllNamed('/halaman_utama');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Halaman Utama',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              barrierDismissible: false,
            );

            return transaksiId;
          } else {
            // Peringatan
            Get.snackbar(
              'Stok Tidak Cukup',
              'Transaksi ID tidak ditemukan.',
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
            return null;
          }
        } else {
          // Gagal / Error
          Get.snackbar(
            'Error',
            'Transaksi gagal',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.error, color: Colors.white),
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
          return null;
        }
      } else {
        // Gagal / Error
        Get.snackbar(
          'Error',
          'Transaksi gagal',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.error, color: Colors.white),
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
        return null;
      }
    } catch (e) {
      // Gagal / Error
      Get.snackbar(
        'Error',
        '$e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
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
      return null;
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  // Fungsi createHutang diubah untuk menerima transaksiId sebagai parameter
  Future<void> createHutang(
      int transaksiId, String nama, double sisaHutang) async {
    var hutang = Hutang(
      transaksiId: transaksiId,
      nama: nama,
      sisaHutang: sisaHutang,
      status: 'belum lunas',
      tanggalMulai: DateTime.now(),
      tanggalSelesai: DateTime.now(),
    );

    print(jsonEncode(hutang.toJson()));

    try {
      var response = await http.post(
        Uri.parse('$apiUrl?action=create_hutang'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(hutang.toJson()),
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['status'] == 'success') {
          Get.snackbar(
            'Success',
            'Hutang berhasil disimpan',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.check_circle, color: Colors.white),
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
        } else {
          // Gagal / Error
          Get.snackbar(
            'Error',
            'Gagal menyimpan hutang',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.error, color: Colors.white),
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
      } else {
        // Gagal / Error
        Get.snackbar(
          'Error',
          'Gagal menyimpan hutang',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.error, color: Colors.white),
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
    } catch (e) {
      // Gagal / Error
      Get.snackbar(
        'Error',
        '$e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
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
  }

  String formatRupiah(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }

  void resetCart() {
    selectedBarangList.clear();
    totalHarga.value = 0.0;
    totalBarang.value = 0;
    bayar.value = 0.0;
    kembali.value = 0.0;
  }

  void toggleButtonPress() {
    isPressed.value = !isPressed.value;
  }
}
