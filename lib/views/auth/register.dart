import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';

class RegisterPage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFE040FB),
                  Color.fromARGB(255, 114, 94, 225),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Image.asset(
                        //   'assets/logo/flutter_logo.png',
                        //   height: 100,
                        // ),
                        // const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                )),
                            const Text(
                              "DAFTAR",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF9C27B0),
                              ),
                            ),
                            const SizedBox(
                              width: 40,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: userController.nameController,
                          decoration: InputDecoration(
                            labelText: 'Nama',
                            contentPadding: const EdgeInsets.only(left: 20),
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: userController.emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            contentPadding: const EdgeInsets.only(left: 20),
                            prefixIcon: const Icon(BootstrapIcons.at),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: userController.passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            contentPadding: const EdgeInsets.only(left: 20),
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: userController.namaTokoController,
                          decoration: InputDecoration(
                            labelText: 'Nama Toko',
                            contentPadding: const EdgeInsets.only(left: 20),
                            prefixIcon: const Icon(Icons.store),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          controller: userController.alamatController,
                          decoration: InputDecoration(
                            labelText: 'Alamat',
                            contentPadding: const EdgeInsets.only(left: 20),
                            prefixIcon: const Icon(Icons.location_on),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: userController.noTeleponController,
                          decoration: InputDecoration(
                            labelText: 'No Telepon',
                            contentPadding: const EdgeInsets.only(left: 20),
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Obx(() {
                          if (userController.isLoading.value) {
                            return const CircularProgressIndicator();
                          } else {
                            return ElevatedButton(
                              onPressed: userController.register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 114, 94, 225),
                                minimumSize: const Size(double.infinity, 48),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                              ),
                              child: const Text(
                                "DAFTAR",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
