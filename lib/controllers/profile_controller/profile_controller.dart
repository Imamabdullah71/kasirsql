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
}
