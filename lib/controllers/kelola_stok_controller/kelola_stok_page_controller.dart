// controllers\barang_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/barang_model.dart';
import 'dart:convert';

class KelolaStokPageController extends GetxController {
  var isLoading = false.obs;
  var barangList = <Barang>[].obs;
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_barang.php';
  final UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    fetchBarang();
    super.onInit();
  }
void fetchBarang() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_barang&user_id=${userController.currentUser.value?.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        barangList.value =
            data.map((barang) => Barang.fromJson(barang)).toList();
      } else {
        // Gagal / Error
        Get.snackbar('Error', 'Gagal mengambil data',
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
        Get.snackbar('Error', '$e',
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
    }
  }

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }
}
