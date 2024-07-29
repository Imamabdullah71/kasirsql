import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/user_model.dart';

class ProfileController extends GetxController {
  final UserController userController = Get.find();

  UserModel? get user => userController.currentUser.value;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (user == null) {
        Get.offAllNamed('/login');
      }
    });
  }

  Future<void> editProfile(String name, String email, String namaToko,
      String alamat, String noTelepon) async {
    if (user != null) {
      UserModel updatedUser = user!.copyWith(
        name: name,
        email: email,
        namaToko: namaToko,
        alamat: alamat,
        noTelepon: noTelepon,
      );
      await userController.saveUserToPreferences(updatedUser);
      Get.back();
      Get.snackbar(
        'Success',
        'Berhasil diperbarui',
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
}
