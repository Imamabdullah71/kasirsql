import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasirsql/models/kategori_model.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';

class KategoriController extends GetxController {
  var allKategoriList = <Kategori>[].obs;
  var kategoriList = <Kategori>[].obs;
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_kategori.php';
  final UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    fetchKategori();
    super.onInit();
  }

  void fetchKategori() async {
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_kategori&user_id=${userController.currentUser.value?.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        allKategoriList.value =
            data.map((kategori) => Kategori.fromJson(kategori)).toList();
        allKategoriList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        kategoriList.value = List.from(allKategoriList);
      } else {
        Get.snackbar(
          'Error',
          'Gagal mendapatkan kategori',
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

  void createKategori(String namaKategori) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=create_kategori'),
        body: {
          'nama_kategori': namaKategori,
          'user_id': userController.currentUser.value?.id.toString(),
        },
      );
      if (response.statusCode == 200) {
        fetchKategori();
        Get.back();
        Get.snackbar(
          'Success',
          'Berhasil menambahkan kategori',
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
          'Gagal membuat kategori',
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

  void deleteKategori(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=delete_kategori'),
        body: {'id': id.toString()},
      );
      if (response.statusCode == 200) {
        fetchKategori();
        Get.snackbar(
          'Success',
          'Berhasil menghapus kategori',
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
          'Gagal menghapus kategori',
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
}
