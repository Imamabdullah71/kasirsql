import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'dart:convert';
import 'package:kasirsql/models/transaksi_model.dart';
import 'package:kasirsql/models/barang_model.dart';

class TransaksiController extends GetxController {
  var selectedBarangList = <Map<String, dynamic>>[].obs;
  var totalHarga = 0.0.obs;
  var totalBarang = 0.obs;
  var bayar = 0.0.obs;
  var kembali = 0.0.obs;
  final String apiUrl = 'http://10.10.10.80/flutterapi/api_transaksi.php';
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
    _updateTotalBarang();
    selectedBarangList.refresh();
    print('Total Barang: ${totalBarang.value}');
  }

  void removeBarangFromCart(Barang barang) {
    var detailBarang =
        selectedBarangList.firstWhere((element) => element['id'] == barang.id);
    selectedBarangList.remove(detailBarang);
    totalHarga.value -= barang.hargaJual;
    _updateTotalBarang();
    selectedBarangList.refresh();
    print('Total Barang: ${totalBarang.value}');
  }

  void updateBarangQuantity(Barang barang, int quantity) {
    var detailBarang =
        selectedBarangList.firstWhere((element) => element['id'] == barang.id);
    totalHarga.value -= detailBarang['harga'] * detailBarang['jumlah'];
    detailBarang['jumlah'] = quantity;
    detailBarang['jumlah_harga'] =
        detailBarang['harga'] * detailBarang['jumlah'];
    totalHarga.value += detailBarang['harga'] * detailBarang['jumlah'];
    _updateTotalBarang();
    selectedBarangList.refresh();
    print('Total Barang: ${totalBarang.value}');
  }

  void _updateTotalBarang() {
    totalBarang.value = selectedBarangList.fold<int>(
        0, (sum, item) => sum + item['jumlah'] as int);
  }

  void createTransaksi() async {
    var now = DateTime.now();
    var userId = userController.currentUser.value?.id;

    if (userId == null) {
      Get.snackbar('Error', 'User tidak ditemukan. Silakan login kembali.');
      return;
    }

    // Buat peta baru dengan hanya nama barang dan jumlah barang
    var simplifiedDetailBarang = selectedBarangList.map((barang) {
      return {
        'nama': barang['nama'],
        'jumlah': barang['jumlah'],
      };
    }).toList();

    var transaksi = Transaksi(
      detailBarang: simplifiedDetailBarang,
      totalBarang: totalBarang.value,
      totalHarga: totalHarga.value,
      bayar: bayar.value,
      kembali: bayar.value - totalHarga.value,
      userId: userId,
      createdAt: now,
      updatedAt: now,
    );

    print(jsonEncode(transaksi.toJson()));

    // Tampilkan data transaksi dalam dialog untuk pengecekan
    Get.defaultDialog(
      title: 'Data Transaksi',
      content: SingleChildScrollView(
        child: Text(
          jsonEncode(
              transaksi.toJson()), // Tampilkan data transaksi dalam bentuk JSON
        ),
      ),
      textConfirm: 'OK',
      onConfirm: () async {
        Get.back();

        // Kirim data transaksi ke API
        try {
          var response = await http.post(
            Uri.parse('$apiUrl?action=create_transaksi'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(transaksi.toJson()),
          );
          if (response.statusCode == 200) {
            var result = json.decode(response.body);
            if (result['status'] == 'success') {
              Get.snackbar('Success', 'Transaksi berhasil dilakukan');
            } else {
              Get.snackbar('Error', 'Transaksi gagal: ${result['message']}');
            }
          } else {
            Get.snackbar('Error', 'Failed to create transaksi');
            print('Error: ${response.body}');
          }
        } catch (e) {
          Get.snackbar('Error', 'Failed to create transaksi');
          print('Exception: $e');
        }
      },
    );
  }

  String formatRupiah(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }
}
