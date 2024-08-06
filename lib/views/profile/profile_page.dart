import 'package:bootstrap_icons/bootstrap_icons.dart';
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
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Profil",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed("/edit_profile"),
            icon: const Icon(
              BootstrapIcons.person_gear,
              size: 30,
            ),
          ),
        ],
        elevation: 10.0, // Add this line to set the shadow
        shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
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
                // Center(
                //   child: CircleAvatar(
                //     radius: 50,
                //     backgroundColor: const Color.fromARGB(255, 114, 94, 225),
                //     child: Text(
                //       profileController.user!.name[0],
                //       style: const TextStyle(
                //         fontSize: 40,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),
                // const SizedBox(height: 10),
                Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: const Text(
                      "Nama",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 114, 94, 225),
                      ),
                    ),
                    subtitle: Text(profileController.user!.name),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: const Text(
                      "Email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 114, 94, 225),
                      ),
                    ),
                    subtitle: Text(profileController.user!.email),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: const Text(
                      "Nama Toko",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 114, 94, 225),
                      ),
                    ),
                    subtitle: Text(profileController.user!.namaToko ?? '-'),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: const Text(
                      "Alamat",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 114, 94, 225),
                      ),
                    ),
                    subtitle: Text(profileController.user!.alamat ?? '-'),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: const Text(
                      "No Telepon",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 114, 94, 225),
                      ),
                    ),
                    subtitle: Text(profileController.user!.noTelepon ?? '-'),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    );
  }
}
