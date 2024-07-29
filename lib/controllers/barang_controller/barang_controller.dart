import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/models/barang_model.dart';
import 'dart:convert';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';

class BarangController extends GetxController {
  var isLoading = false.obs;
  var barangList = <Barang>[].obs;
  var selectedBarang = Rxn<Barang>();
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_barang.php';
  final UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    fetchBarang();
    super.onInit();
  }

  void fetchBarang() async {
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_barang&user_id=${userController.currentUser.value?.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        barangList.value =
            data.map((barang) => Barang.fromJson(barang)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse data');
    }
  }

  void deleteBarang(int id) async {
    isLoading.value = true;

    // Tampilkan dialog loading
    Get.defaultDialog(
      title: 'Loading...',
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
        ],
      ),
      barrierDismissible: false,
    );

    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=delete_barang'),
        body: {
          'id': id.toString(),
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          fetchBarang();
          Get.back();
          Get.back(); 
          Get.snackbar(
            'Success',
            'Barang berhasil dihapus',
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

          // Tunggu durasi snackbar sebelum kembali ke halaman sebelumnya
          await Future.delayed(const Duration(seconds: 3));
        } else {
          Get.snackbar('Error', responseData['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to delete barang');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete barang: $e');
    } finally {
      isLoading.value = false;
      Get.back(); // Pastikan dialog ditutup
    }
  }

  void editBarang(Barang barang) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=update_barang'),
        body: {
          'id': barang.id.toString(),
          'nama_barang': barang.namaBarang,
          'kode_barang': barang.kodeBarang.toString(),
          'stok_barang': barang.stokBarang.toString(),
          'kategori_id': barang.kategoriId.toString(),
          'gambar': barang.gambar ?? '',
          'harga_jual': barang.hargaJual.toString(),
          'harga_beli': barang.hargaBeli.toString(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          fetchBarang();
          Get.back();
          Get.snackbar('Success', 'Barang berhasil diupdate');
        } else {
          Get.snackbar('Error', responseData['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to update barang');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update barang: $e');
    }
  }

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }
}
