// controllers\barang_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/barang_model.dart';
import 'dart:convert';

class KelolaStokController extends GetxController {
  var isLoading = false.obs;
  var barangList = <Barang>[].obs;
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_barang.php';
  final UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    super.onInit();
  }

}
