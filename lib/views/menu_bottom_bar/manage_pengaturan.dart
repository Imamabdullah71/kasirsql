import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';

class ManagePengaturan extends StatelessWidget {
  const ManagePengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "PENGATURAN",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0, // Add this line to set the shadow
        shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ListTile(
            leading: const Icon(BootstrapIcons.person_fill),
            title: const Text("Profil"),
            onTap: () {
              Get.toNamed("/profile");
            },
          ),
          ListTile(
            leading: const Icon(BootstrapIcons.box_arrow_right),
            title: const Text("Logout"),
            onTap: () {
              userController.logout();
            },
          ),
        ],
      ),
    );
  }
}
