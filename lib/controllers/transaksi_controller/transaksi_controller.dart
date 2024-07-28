import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/controllers/transaksi_controller/generate_receipt_controller.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/transaksi_model.dart';
import 'package:kasirsql/models/barang_model.dart';
import 'package:kasirsql/models/detail_transaksi_model.dart';
import 'package:kasirsql/views/transaksi/transaction_success_page.dart';
import 'package:path_provider/path_provider.dart';

class TransaksiController extends GetxController {
  var isLoading = false.obs;
  var selectedBarangList = <Map<String, dynamic>>[].obs;
  var totalHarga = 0.0.obs;
  var totalHargaBeli = 0.0.obs;
  var totalBarang = 0.obs;
  var bayar = 0.0.obs;
  var kembali = 0.0.obs;
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_transaksi.php';
  final UserController userController = Get.find<UserController>();

  Future<List> getTransaksi() async {
    final response = await http.post(
      Uri.parse('$apiUrl?action=get_transaksi'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load transaksi');
    }
  }

  void addBarangToCart(Barang barang) {
    var existingBarangIndex =
        selectedBarangList.indexWhere((element) => element['id'] == barang.id);

    if (existingBarangIndex == -1) {
      selectedBarangList.add({
        'id': barang.id,
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
    } else {
      var existingBarang = selectedBarangList[existingBarangIndex];
      existingBarang['jumlah_barang'] += 1;
      existingBarang['jumlah_harga'] =
          existingBarang['jumlah_barang'] * existingBarang['harga_barang'];
      selectedBarangList[existingBarangIndex] = existingBarang;
    }

    totalHarga.value += barang.hargaJual;
    totalHargaBeli.value += barang.hargaBeli;
    _updateTotalBarang();
    selectedBarangList.refresh();
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
      Get.snackbar('Error', 'User tidak ditemukan. Silakan login kembali.');
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
      isLoading.value = true; // Set loading to true
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
          Get.snackbar('Success', 'Transaksi berhasil dilakukan');
          print('RESPON: ${response.body}');

          var transaksiId = result['transaksi_id'];
          if (transaksiId != null) {
            await _saveDetailTransaksi(transaksiId);

            // Fetch the saved detail transaksi
            List<DetailTransaksi> detailTransaksiList = selectedBarangList.map((barang) {
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

            File receiptFile = File(
                '${(await getApplicationDocumentsDirectory()).path}/receipt_$transaksiId.png');

            var uri = Uri.parse('$apiUrl?action=upload_struk');
            var request = http.MultipartRequest('POST', uri)
              ..fields['transaksi_id'] = transaksiId.toString()
              ..files.add(await http.MultipartFile.fromPath('struk', receiptFile.path));

            var uploadResponse = await request.send();
            if (uploadResponse.statusCode == 200) {
              var responseData = await uploadResponse.stream.bytesToString();
              var uploadResult = json.decode(responseData);
              if (uploadResult['status'] == 'success') {
                Get.to(() => TransactionSuccessPage(receiptFile: receiptFile));
              } else {
                Get.snackbar('Error', 'Gagal mengunggah struk: ${uploadResult['message']}');
              }
            } else {
              Get.snackbar('Error', 'Gagal mengunggah struk');
            }
          } else {
            Get.snackbar('Error', 'Transaksi ID tidak ditemukan.');
          }
        } else {
          Get.snackbar('Error', 'Transaksi gagal: ${result['message']}');
        }
      } else {
        Get.defaultDialog(
          title: 'Gagal',
          content: SingleChildScrollView(
            child: Text(response.body),
          ),
          textConfirm: 'Okay',
          onConfirm: () => Get.back(),
        );
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Error',
        content: SingleChildScrollView(
          child: Text('$e'),
        ),
        textConfirm: 'Okay',
        onConfirm: () => Get.back(),
      );
    } finally {
      isLoading.value = false; // Set loading to false
      Get.back(); // Close loading dialog
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
      } catch (e) {
        Get.snackbar('Error', 'Gagal menyimpan detail transaksi: $e');
      }
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
}
