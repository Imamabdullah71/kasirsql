// menu_bottom_bar\manage_pengaturan.dart
import 'package:flutter/material.dart';

class ManagePengaturan extends StatelessWidget {
  const ManagePengaturan({super.key});

  @override
  Widget build(BuildContext context) {
    // final AuthController authController = Get.find<AuthController>();
    // final user = authController.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius:
                  50.0, // Mengatur radius menjadi 50.0, ini menentukan ukuran lingkaran
              // backgroundImage: AssetImage('assets/images/barang/coklat.jpg'), // Gambar untuk avatar
              // Jika ingin menggunakan warna latar belakang:
              backgroundColor: Colors.grey[300],
              // Jika ingin menggunakan ikon sebagai gambar:
              child: const Icon(Icons.person, size: 50.0),
            ),
            const SizedBox(height: 20),
            const Text(
              "Profil",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 500,
              width: double.infinity,
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nama"),
                    const SizedBox(height: 10),
                    // Text(user?.displayName ?? "Nama Pemilik"),
                    const SizedBox(height: 20),
                    const Text("Email"),
                    const SizedBox(height: 10),
                    // Text(user?.email ?? "email@gmail.com"),
                    const SizedBox(height: 20),
                    const Text("Telepon"),
                    const SizedBox(height: 10),
                    const Text("08731253614"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // authController.logoutFC();
                      },
                      child: const Text("Logout"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // if (user != null) {
                        //   Get.dialog(
                        //     AlertDialog(
                        //       title: const Text("Raw User Data"),
                        //       content: SingleChildScrollView(
                        //         child: Text(user.toString()),
                        //       ),
                        //       actions: [
                        //         TextButton(
                        //           onPressed: () {
                        //             Get.back();
                        //           },
                        //           child: const Text("Close"),
                        //         ),
                        //       ],
                        //     ),
                        //   );
                        // } else {
                        //   Get.snackbar("Error", "User not logged in");
                        // }
                      },
                      child: const Text("Lihat Raw data"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
