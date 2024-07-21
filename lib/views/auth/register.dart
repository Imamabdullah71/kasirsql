import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';

class RegisterPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: userController.nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: userController.emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: userController.passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              TextField(
                controller: userController.namaTokoController,
                decoration: const InputDecoration(labelText: "Nama Toko"),
              ),
              TextField(
                controller: userController.alamatController,
                decoration: const InputDecoration(labelText: "Alamat"),
              ),
              TextField(
                controller: userController.noTeleponController,
                decoration: const InputDecoration(labelText: "No Telepon"),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (userController.isLoading.value) {
                  return const CircularProgressIndicator();
                } else {
                  return ElevatedButton(
                    onPressed: userController.register,
                    child: const Text("Register"),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
