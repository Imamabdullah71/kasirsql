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
      print("Loaded user data: $userData"); // Log data yang diambil
      currentUser.value = UserModel.fromJson(json.decode(userData));
    }
  }

  Future<void> saveUserToPreferences(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = json.encode(user.toJson());
    print("Saving user data: $userJson"); // Log data yang disimpan
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
      Uri.parse('http://192.168.135.56/flutterapi/api_user.php'),
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
        Get.snackbar('Success', data['message']);
        Get.to(() => LoginPage()); // Navigate to login page on success
      } else {
        Get.snackbar('Error', data['message']);
      }
    } else {
      Get.snackbar('Error', 'Failed to register');
    }
  }

  Future<bool> login() async {
    isLoading.value = true;

    final response = await http.post(
      Uri.parse('http://192.168.135.56/flutterapi/api_user.php'),
      body: {
        'action': 'login',
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    isLoading.value = false;

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        print("Login response data: ${data['user']}"); // Log data respon login
        UserModel user = UserModel.fromJson(data['user']);
        await saveUserToPreferences(user);
        Get.snackbar('Success', 'Logged in successfully');
        return true;
      } else {
        Get.snackbar('Error', data['message']);
        return false;
      }
    } else {
      Get.snackbar('Error', 'Failed to login');
      return false;
    }
  }

  Future<void> logout() async {
    await clearUserPreferences();
    Get.offAllNamed('/login');
    Get.snackbar('Berhasil', 'Berhasil logout');
  }
}
