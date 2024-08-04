import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/barang_model.dart';
import 'dart:convert';

class KelolaStokController extends GetxController {
  var isLoading = false.obs;
  var barangList = <Barang>[].obs;
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_stok.php';
  final UserController userController = Get.find<UserController>();

  Future<void> updateStokBarang(int id, int newStok, String action) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'id': id.toString(),
          'new_stok': newStok.toString(),
          'action': 'update_stok_barang',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          Get.find<BarangController>().fetchBarang();
          // Get.back();
          Get.snackbar(
            'Success',
            'Stok berhasil diupdate',
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
        _showErrorSnackbar('Gagal memperbarui stok barang');
      }
    } catch (e) {
      _showErrorSnackbar('$e');
    } finally {
      isLoading.value = false;
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
}
