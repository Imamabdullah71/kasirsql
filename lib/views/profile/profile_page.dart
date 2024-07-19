import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/profile_controller/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Profile"),
      ),
      body: Obx(() {
        if (profileController.user == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID: ${profileController.user!.id}"),
                Text("Name: ${profileController.user!.name}"),
                Text("Email: ${profileController.user!.email}"),
                Text("Nama Toko: ${profileController.user!.namaToko ?? '-'}"),
                Text("No Telepon: ${profileController.user!.noTelepon ?? '-'}"),
              ],
            ),
          );
        }
      }),
    );
  }
}
