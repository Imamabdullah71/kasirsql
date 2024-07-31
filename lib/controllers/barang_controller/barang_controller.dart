import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/models/barang_model.dart';
import 'dart:convert';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';

class BarangController extends GetxController {
  var isLoading = false.obs;
  var isPressed = false.obs; // Observable for button press state
  var allBarangList = <Barang>[].obs; // Semua barang asli
  var filteredBarangList = <Barang>[].obs; // Barang yang difilter
  var kategoriList = <String>[].obs; // Daftar kategori
  var selectedBarang = Rxn<Barang>();
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_barang.php';
  final UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    fetchBarang();
    fetchKategori(); // Panggil fungsi fetchKategori saat inisialisasi
    super.onInit();
  }

  void fetchBarang() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_barang&user_id=${userController.currentUser.value?.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        allBarangList.value =
            data.map((barang) => Barang.fromJson(barang)).toList();

        // Mengurutkan allBarangList berdasarkan createdAt dari yang terbaru terlebih dahulu
        allBarangList.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        filteredBarangList.value =
            allBarangList; // Set filtered list sama dengan semua barang
      } else {
        _showErrorSnackbar('Gagal Mengambil Data');
      }
    } catch (e) {
      _showErrorSnackbar('Gagal mengumpulkan Data');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchKategori() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_kategori&user_id=${userController.currentUser.value?.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        kategoriList.value = data
            .map((kategori) => kategori['nama_kategori'] as String)
            .toList();
      } else {
        _showErrorSnackbar('Gagal Mengambil Data Kategori');
      }
    } catch (e) {
      _showErrorSnackbar('Gagal mengumpulkan Data Kategori');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteBarang(int id) async {
    isLoading.value = true;
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
        body: {'id': id.toString()},
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          fetchBarang();
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
          );
          await Future.delayed(const Duration(seconds: 3));
        } else {
          _showErrorSnackbar(responseData['message']);
        }
      } else {
        _showErrorSnackbar('Gagal menghapus data barang');
      }
    } catch (e) {
      _showErrorSnackbar('$e');
    } finally {
      isLoading.value = false;
      Get.back();
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
          Get.snackbar(
            'Success',
            'Barang berhasil diupdate',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 3),
            snackStyle: SnackStyle.FLOATING,
          );
        } else {
          _showErrorSnackbar(responseData['message']);
        }
      } else {
        _showErrorSnackbar('Gagal memperbarui data barang');
      }
    } catch (e) {
      _showErrorSnackbar('$e');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
    );
  }

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  void toggleButtonPress() {
    isPressed.value = !isPressed.value;
  }
}
