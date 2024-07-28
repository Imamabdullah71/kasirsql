import 'package:bootstrap_icons/bootstrap_icons.dart';
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
      body: Stack(
        children: [
          Container(
            height: 300,
            width: double.infinity,
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
            child: Padding(
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 120,
              ),
              child: Image.asset(
                'assets/logo/flutter_logo.png',
                height: 100,
                width: 100,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(
                top: 200, left: 16, right: 16, bottom: 16),
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
                    const Text(
                      "SIGN IN",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: userController.emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(BootstrapIcons.at),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: userController.passwordController,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 10),
                    Obx(() => CheckboxListTile(
                          title: const Text("Remember me"),
                          value: rememberMe.value,
                          activeColor: const Color(0xFF9C27B0),
                          onChanged: (newValue) {
                            rememberMe.value = newValue!;
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color(0xFF9C27B0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (userController.isLoading.value) {
                        return const CircularProgressIndicator();
                      } else {
                        return ElevatedButton(
                          onPressed: () async {
                            bool success = await userController.login();
                            if (success) {
                              final BottomBarController bottomBarController =
                                  Get.find();
                              bottomBarController.resetToHome();
                              Get.offAllNamed('/halaman_utama');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 114, 94, 225),
                            minimumSize: const Size(double.infinity, 48),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                          ),
                          child: const Text(
                            "SIGN IN",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum punya akun?"),
                        TextButton(
                          onPressed: () {
                            Get.toNamed("/register");
                          },
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                              color: Color(0xFF9C27B0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
