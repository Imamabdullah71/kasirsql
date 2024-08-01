// menu_bottom_bar\manage_transaksi.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class ManageTransaksi extends StatelessWidget {
  const ManageTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "TRANSAKSI",
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
            leading: const Icon(BootstrapIcons.cart3),
            title: const Text("Transaksi"),
            onTap: () {
              Get.toNamed("/transaksi_page");
            },
          ),
          ListTile(
            leading: const Icon(BootstrapIcons.clock_history),
            title: const Text("History Transaction"),
            onTap: () {
              Get.toNamed("/riwayat_transaksi");
            },
          ),
        ],
      ),
    );
  }
}
