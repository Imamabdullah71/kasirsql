import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kasirsql/views/auth/login.dart';
import 'package:kasirsql/models/user_model.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var currentUser = Rxn<UserModel>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController namaTokoController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController noTeleponController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserFromPreferences();
  }

  Future<void> loadUserFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (userData != null) {
      print("Loaded user data: $userData");
      currentUser.value = UserModel.fromJson(json.decode(userData));
    }
  }

  Future<void> saveUserToPreferences(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = json.encode(user.toJson());
    print("Saving user data: $userJson");
    await prefs.setString('user', userJson);
    currentUser.value = user;
  }

  Future<void> clearUserPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    currentUser.value = null;
  }

  Future<void> register() async {
    isLoading.value = true;

    final response = await http.post(
      Uri.parse('http://10.10.10.129/flutterapi/api_user.php'),
      body: {
        'action': 'register',
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'nama_toko': namaTokoController.text,
        'alamat': alamatController.text,
        'no_telepon': noTeleponController.text,
      },
    );

    isLoading.value = false;

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        Get.snackbar(
          'Success',
          data['message'],
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
        Get.to(() => LoginPage());
      } else if (data['message'] == 'Email sudah terdaftar') {
        Get.snackbar(
          'Peringatan',
          'Email sudah terdaftar.',
          backgroundColor: const Color.fromARGB(255, 235, 218, 63),
          colorText: Colors.black,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: const Icon(BootstrapIcons.exclamation_triangle_fill,
              color: Colors.black),
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
          data['message'],
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
    } else {
      Get.snackbar(
        'Error',
        'Failed to register',
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

  Future<bool> login() async {
    isLoading.value = true;
    Get.defaultDialog(
      title: 'Loading...',
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Proses login sedang berlangsung'),
        ],
      ),
      barrierDismissible: false,
    );

    try {
      final response = await http.post(
        Uri.parse('http://10.10.10.129/flutterapi/api_user.php'),
        body: {
          'action': 'login',
          'email': emailController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          print("Login response data: ${data['user']}");
          UserModel user = UserModel.fromJson(data['user']);
          await saveUserToPreferences(user);
          Get.snackbar(
            'Success',
            'Berhasil Login',
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
          return true;
        } else {
          Get.snackbar(
            'Error',
            data['message'],
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
          return false;
        }
      } else {
        // Gagal / Error
        Get.snackbar(
          'Error',
          'Gagal Login',
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
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
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
      return false;
    } finally {
      isLoading.value = false;
      Get.back();
    }
  }

  Future<void> logout() async {
    await clearUserPreferences();
    Get.offAllNamed('/login');
    // Berhasil
    Get.snackbar(
      'Success',
      'Berhasil logout',
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
  }
}
