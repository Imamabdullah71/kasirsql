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
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
        title: Text(
          "Transaksi".toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
          ListTile(
            leading: const Icon(BootstrapIcons.file_earmark_text),
            title: const Text("Hutang"),
            onTap: () {
              Get.toNamed("/hutang_page");
            },
          ),
        ],
      ),
    );
  }
}
