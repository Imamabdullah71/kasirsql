import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasirsql/models/supplier_model.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart'; // Import UserController

class SupplierController extends GetxController {
  var supplierList = <Supplier>[].obs;
  final String apiUrl = 'http://10.0.171.198/flutterapi/api_supplier.php';
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
        Get.snackbar('Error', 'Gagal menampilkan Supplier');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memproses supplier');
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
                "Supplier berhasil dihapus",
                "",
                duration: const Duration(seconds: 3),
                backgroundColor: Colors.green,
                colorText: Colors.white,
                borderRadius: 10.0,
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                snackPosition: SnackPosition.TOP,
                forwardAnimationCurve: Curves.easeOut,
                reverseAnimationCurve: Curves.easeIn,
                isDismissible: true,
                showProgressIndicator: false,
              );
            } else {
              Get.snackbar('Error', 'Gagal menghapus supplier');
            }
          } catch (e) {
            Get.snackbar('Error', 'Gagal memproses hapus');
          }
        },
        textConfirm: "Ya",
        textCancel: "Kembali",
        onCancel: () => Get.back(),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete supplier');
    }
  }
}
