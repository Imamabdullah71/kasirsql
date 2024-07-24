import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/controllers/transaksi_controller/generate_receipt_controller.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/transaksi_model.dart';
import 'package:kasirsql/models/barang_model.dart';
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
        'nama': barang.namaBarang,
        'harga': barang.hargaJual,
        'jumlah': 1,
        'jumlah_harga': barang.hargaJual,
        'kode_barang': barang.kodeBarang,
        'stok_barang': barang.stokBarang,
        'kategori_id': barang.kategoriId,
        'nama_kategori': barang.namaKategori,
        'harga_beli': barang.hargaBeli,
      });
    } else {
      var existingBarang = selectedBarangList[existingBarangIndex];
      existingBarang['jumlah'] += 1;
      existingBarang['jumlah_harga'] =
          existingBarang['jumlah'] * existingBarang['harga'];
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
    totalHarga.value -= detailBarang['harga'] * detailBarang['jumlah'];
    totalHargaBeli.value -= detailBarang['harga_beli'] * detailBarang['jumlah'];
    detailBarang['jumlah'] = quantity;
    detailBarang['jumlah_harga'] =
        detailBarang['harga'] * detailBarang['jumlah'];
    totalHarga.value += detailBarang['harga'] * detailBarang['jumlah'];
    totalHargaBeli.value += detailBarang['harga_beli'] * detailBarang['jumlah'];
    _updateTotalBarang();
    selectedBarangList.refresh();
    print('Total Barang: ${totalBarang.value}');
  }

  void _updateTotalBarang() {
    totalBarang.value = selectedBarangList.fold<int>(
        0, (sum, item) => sum + item['jumlah'] as int);
  }

  Future<void> createTransaksi() async {
    var now = DateTime.now();
    var userId = userController.currentUser.value?.id;

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan. Silakan login kembali.');
      return;
    }

    var simplifiedDetailBarang = selectedBarangList.map((barang) {
      return {
        'nama': barang['nama'],
        'jumlah': barang['jumlah'],
        'hjb': barang['harga'],
        'harga_total': barang['jumlah_harga'],
      };
    }).toList();

    var transaksi = Transaksi(
      detailBarang: simplifiedDetailBarang,
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
            await Get.find<GenerateReceiptController>()
                .generateReceipt(transaksi, transaksiId);
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

  String formatRupiah(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }
}
