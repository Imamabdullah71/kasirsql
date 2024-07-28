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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ListTile(
            leading: const Icon(BootstrapIcons.person_fill),
            title: const Text("Profile"),
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
