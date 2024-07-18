import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/controllers/bottom_bar_controller.dart';

class LoginPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final rememberMe = false.obs;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: userController.emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: userController.passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            Obx(() => CheckboxListTile(
              title: const Text("Remember Me"),
              value: rememberMe.value,
              onChanged: (newValue) {
                rememberMe.value = newValue!;
              },
            )),
            const SizedBox(height: 20),
            Obx(() {
              if (userController.isLoading.value) {
                return const CircularProgressIndicator();
              } else {
                return ElevatedButton(
                  onPressed: () async {
                    bool success = await userController.login();
                    if (success) {
                      final BottomBarController bottomBarController = Get.find();
                      bottomBarController.resetToHome(); // Reset to Home page
                      Get.offNamed('/halaman_utama'); // Navigasi ke halaman utama setelah login berhasil
                    }
                  },
                  child: const Text("Login"),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
