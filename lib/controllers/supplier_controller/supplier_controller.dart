import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasirsql/models/supplier_model.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart'; // Import UserController

class SupplierController extends GetxController {
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_supplier.php';
  final UserController userController =
      Get.find<UserController>(); // Dapatkan UserController
  var supplierList = <Supplier>[].obs;
  var allSupplierList = <Supplier>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchSupplier();
    super.onInit();
  }

  void fetchSupplier() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_supplier&user_id=${userController.currentUser.value?.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        allSupplierList.value =
            data.map((supplier) => Supplier.fromJson(supplier)).toList();
        allSupplierList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        supplierList.value = allSupplierList;
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  void searchSupplier(String query) {
    if (query.isEmpty) {
      supplierList.value = allSupplierList;
    } else {
      supplierList.value = allSupplierList.where((supplier) {
        return (supplier.namaSupplier
                .toLowerCase()
                .contains(query.toLowerCase())) ||
            (supplier.namaTokoSupplier
                    ?.toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (supplier.noTelepon?.toLowerCase().contains(query.toLowerCase()) ??
                false);
      }).toList();
    }
  }

  void sortSupplierList(String order) {
    switch (order) {
      case 'name_asc':
        supplierList.sort((a, b) => a.namaSupplier.compareTo(b.namaSupplier));
        break;
      case 'name_desc':
        supplierList.sort((a, b) => b.namaSupplier.compareTo(a.namaSupplier));
        break;
    }
  }

  void updateSupplier(int id, String namaSupplier, String namaTokoSupplier,
      String noTelepon, String alamat) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=update_supplier'),
        body: {
          'id': id.toString(),
          'nama_supplier': namaSupplier,
          'nama_toko_supplier': namaTokoSupplier,
          'no_telepon': noTelepon,
          'alamat': alamat,
        },
      );
      if (response.statusCode == 200) {
        fetchSupplier();
        Get.snackbar(
          'Success',
          'Supplier berhasil diupdate',
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
        Get.snackbar(
          'Error',
          'Gagal mengupdate supplier',
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
