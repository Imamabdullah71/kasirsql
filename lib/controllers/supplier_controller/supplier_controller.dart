import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasirsql/models/supplier_model.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart'; // Import UserController

class SupplierController extends GetxController {
  var supplierList = <Supplier>[].obs;
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_supplier.php';
  final UserController userController =
      Get.find<UserController>(); // Dapatkan UserController

  @override
  void onInit() {
    fetchSupplier();
    super.onInit();
  }

  void fetchSupplier() async {
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_supplier&user_id=${userController.currentUser.value?.id}')); // Gunakan user_id
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        supplierList.value =
            data.map((supplier) => Supplier.fromJson(supplier)).toList();
      } else {
        // Gagal / Error
        Get.snackbar(
          'Error',
          'Gagal menampilkan Supplier',
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

  void deleteSupplier(int id) async {
    try {
      Get.defaultDialog(
        title: "Apakah yakin ingin menghapus data?",
        middleText: "Data akan dihapus permanen!",
        onConfirm: () async {
          try {
            final response = await http.post(
              Uri.parse('$apiUrl?action=delete_supplier'),
              body: {'id': id.toString()},
            );
            if (response.statusCode == 200) {
              fetchSupplier();
              Get.back();
              Get.snackbar(
                'Success',
                'Berhasil menghapus supplier',
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
                'Gagal menghapus supplier',
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
        },
        textConfirm: "Ya",
        textCancel: "Kembali",
        onCancel: () => Get.back(),
      );
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
    }
  }
}
